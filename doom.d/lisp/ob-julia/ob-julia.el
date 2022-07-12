;;; ob-julia --- Org Mode babel support for julia, using ESS
;;; Commentary:
;; This package adds Julia support to Org Mode src block evaluation
;;; Code:
(require 'ob)
(require 'seq)
(eval-when-compile (require 'cl))

(defcustom org-babel-julia-command "julia"
  "Name of command to use for executing julia code."
  :group 'org-babel
  :version "24.1"
  :type 'string)

(defcustom ob-julia-startup-script
  (concat (file-name-directory (or load-file-name (buffer-file-name)))
   "init.jl")
  "Julia file path to run at startup.  Must be absolute."
  :group 'org-babel
  :version "24.1"
  :type 'string)

(defcustom org-babel-julia-table-as-dict nil
  "If t, tables are imported as Dictionary, else as NamedTuple.
In both cases, if you use DataFrames you can pass them to
`DataFrame'.
Importing NamedTuple is slower (more data) but they preserve the column order."
  :group 'org-babel
  :version "24.1"
  :type 'boolean)

(defcustom org-babel-julia-silent-repl nil
  "Disable printing results in julia REPL.

When non-nil, do not print org-src evaluation result in julia
session REPL.  Since printing results require extra
compuatations, if you never look at the REPL setting this non-nil
this might be desired.
There's no effect in non-session evaluations"
  :group 'org-babel
  :version "24.1"
  :type 'boolean)

(defcustom org-babel-julia-debug nil
  "Enable sending messages with debugging information."
  :group 'org-babel
  :version "24.1"
  :type 'boolean)

(defconst org-babel-header-args:julia
  '((width		 . :any)
    (height		 . :any)
    (size		 . :any)
    (inline		 . :any)
    (let		 . :any)
    (import		 . :any)
    (using		 . :any)
    (async		 . :any)
    (results		 . ((file
			     matrix table
			     list
			     ;; vector table scalar verbatim
			     )
			    (raw html latex org
				 ;; code pp drawer
				 )
			    (replace silent none append prepend)
			    (output value))))
  "Julia-specific header arguments.")

(defvar org-babel-default-header-args:julia '())
(defvar org-babel-julia-default-session "*julia*")

(defvar ess-ask-for-ess-directory nil) ; dynamically scoped
(defvar org-babel-julia-session-directory)

(defun org-babel-prep-session:julia (session params)
  "Prepare SESSION according to the header arguments specified in PARAMS."
  (let ((dir (or (cdr (assoc :dir params))
		 (inferior-ess--maybe-prompt-startup-directory
		  org-babel-julia-command "julia"))))
    (set (make-local-variable 'org-babel-julia-session-directory) dir)
    (save-window-excursion
      (require 'ess)
      (require 'ess-julia)
      ;; load the julia startup script (defined in ob-julia-startup-script)
      ;; pass it along with other arguments defined in inferior-julia-args
      (let* ((start-script-arg
	      (concat (format "--load=%s" ob-julia-startup-script)))
	     (inferior-julia-args (if inferior-julia-args
				      (concat inferior-julia-args start-script-arg)
				    start-script-arg)))
	(switch-to-buffer (julia)))
      (rename-buffer
       (if (bufferp session)
	   (buffer-name session)
	 (if (stringp session)
	     session
	   (buffer-name))))
      ;; Register the async callback. Important to do this before
      ;; running the command
      (set-process-filter (get-buffer-process
			   (org-babel-comint-buffer-livep session))
			  'org-julia-async-process-filter))))

(defun org-babel-julia-get-session-name (params)
  "Extract the session name from the PARAMS.

If session should not be used, return nil.

 session can be:
 - (:session) :: param passed, empty, use default
 - (:session name) :: param passed, with a name, use it
 - (:session none) :: param not passed, do not use the session"
  (let ((session (cdr (assoc :session params))))
    (cond
     ((null session) org-babel-julia-default-session)
     ((string-equal session "none") nil)
     (t session))))

(defun org-julia-async-process-filter (process output)
  "Replace julia-async: tags with async results.
Takes OUTPUT from PROCESS, tries to extract from the
ob_julia_async the `uuid' in the `org-mode' buffer name.  Then,
searches for the `uuid' in the `org-mode' buffer, and replaces it
with the output file content.

This function is used for all async processing with and without session."
  (if (string-match "ob_julia_async_\\([0-9a-z\\-]+\\)_\\(.+\\)" output)
      ;; capture ob-julia ouptut
      (progn
	(let ((uuid (match-string-no-properties 1 output))
	      (org-buffer (match-string-no-properties 2 output))
	      new-hash results params cache info)
	  (save-window-excursion
	    (save-excursion
	      (switch-to-buffer org-buffer)
	      (save-restriction
		;; If it's narrowed, substitution would fail
		(widen)
		;; search the matching src block
		(goto-char (point-max))
		(when (search-backward (concat "julia-async:" uuid) nil t)
		  ;; get output file name (stored in the buffer
		  (setq results
			(let ((line (buffer-substring-no-properties
				     (line-beginning-position)
				     (line-end-position))))
			  (when (string-match "julia-async:.+:\\([^\s]*\\)"
					      line)
			    (match-string-no-properties 1 line))))
		  ;; remove results
		  (search-backward "#+end_src")
		  (setq info (org-babel-get-src-block-info 'light))
		  ;; This will evaluate the code again
		  ;; (cl-callf org-babel-process-params (nth 2 info))
		  (setq params (nth 2 info))
		  (setq cache (ob-julia-check-trueness params :cache))
		  ;; pass info to have a different hash
		  (setq new-hash (if cache (org-babel-sha1-hash) nil))
		  (org-babel-remove-result)
		  ;; insert new one
		  (org-babel-insert-result
		   (org-babel-julia-process-results results params 'callback)
		   (cdr (assq :result-params params))
		   info new-hash "julia")))))
	  (inferior-ess-output-filter process "\n")))
    ;; This is the standard
    (inferior-ess-output-filter process output)))

(defun org-babel-julia-evaluate-external-process (block outfile params buffer)
  "Evaluate julia SRC code, according to PARAMS.
Does not rely on an ESS session."
  (let* ((uuid (org-id-uuid))
	 (command (format
		   "%s;println(string(\"ob_julia_async_\", %S, \"_\", %S))"
		   block uuid buffer))
	 (tmpfile (make-temp-file "ob-julia" nil ".jl" block)))
    (if (and (org-babel-julia-async-p params)
	     (org-babel-julia-really-async-p))
	(progn
	  (make-process :name "*julia-async-process*"
			:filter #'org-julia-async-process-filter
			:command `(,org-babel-julia-command
				   "--load" ,ob-julia-startup-script
				   "--eval"
				   ,(format "include(%S);%s" tmpfile command)))
	  (concat "julia-async:" uuid ":" outfile))
      (progn
	(shell-command
	 (format "%s --load %s %s" org-babel-julia-command
		 ob-julia-startup-script tmpfile))
	outfile))))

(defun org-babel-julia-assign-to-var-or-array (var)
  ""
  (if (listp (cdr var))
      (org-babel-julia-assign-to-array (car var) (cdr var))
    (org-babel-julia-assign-to-var (car var) (cdr var))))

(defun org-babel-julia-assign-to-array (name matrix)
  "Create a Matrix (Vector{Any,2} from `MATRIX' and assign it to `NAME'"
  (format "%s = [%s]" name
	  (mapconcat (lambda (line) (mapconcat (lambda (e)
						 (format "%S" e))
					       line " ")) matrix ";")))

(defun org-babel-julia-assign-to-var (name value)
  "Assign `VALUE' to a variable called `NAME'."
  (format "%s = %S" name value))

(defun org-babel-julia-assign-to-dict (name column-names values)
  "Create a Dict with lists as values.
Create a Dict where keys are Symbol from `COLUMN-NAMES',
values are Array taken from `VALUES', and assign it to `NAME'"
  (format "%s = Dict(%s)" name
	  (mapconcat
	   (lambda (i)
	     (format "Symbol(\"%s\") => [%s]" (nth i column-names)
		     (mapconcat
		      (lambda (line) (format "%S" (nth i line)))
		      values
		      ",")))
	   (number-sequence 0 (1- (length column-names)))
	   ",")))

(defun org-babel-julia-assign-to-named-tuple (name column-names values)
  "Create a NamedTuple using (; zip([], [])...)"
  (let ((res (format "%s = [%s]" name
		     (mapconcat
		      (lambda (i)
			(concat
			 "(; zip(["
			 (mapconcat
			  (lambda (col) (format "Symbol(\"%s\")" col))
			  column-names ", ")
			 "],["
			 (mapconcat
			  (lambda (cell) (format "\"%s\"" cell))
			  (nth i values)
			  ",")
			 "])...)"))
		      (number-sequence 0 (1- (length values))) ", "))))
    (message res)
    res))

(defun org-babel-variable-assignments:julia (params)
  "Return list of julia statements assigning the block's variables."
  (let ((vars (org-babel--get-vars params))
	(colnames (cdr (assoc :colname-names params))))
    (mapcar (lambda (i)
	      (let* ((var (nth i vars))
		     (column-names
		      (car (seq-filter
			    (lambda (cols)
			      (eq (car cols) (car var)))
			    colnames))))
		(if column-names
		    (if org-babel-julia-table-as-dict
			(org-babel-julia-assign-to-dict
			 (car var) (cdr column-names) (cdr var))
		      (org-babel-julia-assign-to-named-tuple
		       (car var) (cdr column-names) (cdr var)))
		  (org-babel-julia-assign-to-var-or-array var))))
	    (number-sequence 0 (1- (length vars))))))

(defun org-babel-julia-make-kwargs (args)
  ""
  (format "(%s)" (mapconcat (lambda (arg)
			      (format "%s=%s,"
				      (car arg)
				      (cdr arg)))
			    (seq-filter (lambda (arg) (cdr arg)) args) "")))

(defun org-babel-julia-block-expand (params srcfile outfile)
  "Takes BODY, apply required PARAMS and return the Julia code.

OUTFILE and FILE can either be a string or nil.
If FILE is defined, output is _save()_d to a file with that name.
else OUTFILE is used, and data is _write()_ to it."
  (let* ((vars (mapconcat 'concat (org-babel-variable-assignments:julia params) ";"))
	 (varsfile (make-temp-file "ob-julia-vars-" nil ".jl" vars))
	 (dir (or (cdr (assoc :dir params)) default-directory))
	 (using-param (cdr (assoc :using params)))
	 (using (if using-param (split-string using-param) nil))
	 (import-param (cdr (assoc :import params)))
	 (import (if import-param (split-string import-param ";") nil))
	 (result-type (cdr (assoc :result-type params)))
	 (output-type (case result-type (value ":value") (output ":output")))
	 ;; kwargs
	 (size (cdr (assoc :size params)))
	 (width (cdr (assoc :width params)))
	 (height (cdr (assoc :height params))))
    (concat
     (if (or using import)
	 (format "OrgBabelImport(%S);OrgBabelReload();"
		 (concat (if using (mapconcat (lambda (x) (concat "using " x))
					      using "\n") "")
			 "\n"
			 (if import (mapconcat (lambda (x) (concat "import " x))
					       import "\n") "")))
       "")
     (format
      "OrgBabelFormat(%s,%S,%S,%S,%S,%s,%s,%S);"
      output-type outfile
      dir
      varsfile srcfile
      (if org-babel-julia-silent-repl
	  "true" "false")
      (if (ob-julia-check-trueness params :let)
	  "true" "false")
      (org-babel-julia-make-kwargs `((width . ,width)
				     (height . ,height)
				     (size . ,size)))))))

(defun org-babel-execute:julia-async (buffer session body block output params)
  (let* ((uuid (org-id-uuid))
	 ;; The whole line must be printed in as single statement
	 ;; (ob_julia_async...) or you can receive only a portion of
	 ;; it. But cannot be joined together (else it will trigger
	 ;; immediately). That's why I'm using string(..)
	 (command
	  (format "%s;println(string(\"ob_julia_async_\", %S, \"_\", %S))" block
		  uuid buffer)))
    (progn
      (org-babel-remove-result)
      (process-send-string session (concat command "\n"))
      ;; store the command in input history!
      (with-current-buffer session
      	(comint-add-to-input-history body)))
    (concat "julia-async:" uuid ":" output)))

(defun org-babel-execute:julia-sync (session body block output params)
  "Run FILE, in session `SESSION`, synchronously.
PARAMS are passed"
  (org-babel-comint-eval-invisibly-and-wait-for-file
   session output block 0.1)
  (with-current-buffer session
    (comint-add-to-input-history body))
  output)

(defun org-babel-julia-process-value-result (results type)
  "Insert hline if needed (combining info from RESULT and TYPE."
  ;; add an hline if the result seems to be a table
  ;; always obay explicit type
  (if (or (eq type 'table)
	  (and (eq type 'auto)
	       (listp results)		  ; a table must be a list
	       (listp (car results))	  ; of lists
	       (stringp (caar results)))) ; with strings as first line
      (cons (car results) (cons 'hline (cdr results)))
    results))

(defun org-babel-julia-process-results (results params &optional callback)
  "Decides what to insert as result.
If PARAMS is :async, insert a link, unless CALLBACK is true."
  (let ((result-type (org-babel-julia-parse-result-type params))
	(file (cdr (assoc :file params)))
	(inlined (org-babel-julia-get-inline-type params))
	(async (org-babel-julia-async-p params))
	(session (org-babel-julia-get-session-name params))
	(res (cdr (assoc :results params))))
    (if (and async
	     (not callback)
	     (org-babel-julia-really-async-p))
	results
      (unless file			; do not process files
	(when org-babel-julia-debug
	  (message (format "Processing results %s" results)))
	(if inlined
	    (with-temp-buffer
	      (when (bound-and-true-p org-export-current-backend)
		(insert (format "#+begin_export %s\n"
				(if org-export-current-backend
				    org-export-current-backend
				  inlined))))
	      (insert-file-contents results)
	      (when (bound-and-true-p org-export-current-backend)
		(goto-char (point-max))
		(insert "\n#+end_export"))
	      (buffer-string))
	  (org-babel-result-cond (if res (split-string res) nil)
	    (with-temp-buffer
	      (when org-babel-julia-debug (message res))
	      (insert-file-contents results)
	      (buffer-string))
	    (org-babel-julia-process-value-result
	     (org-babel-import-elisp-from-file results '(4))
	     result-type)))))))

(defun org-babel-julia-parse-result-type (params)
  "Decide how to parse results. Default is \"auto\"
(results can be anything. If \"table\", force parsing as a
table. To force a matrix, use matrix"
  (let* ((results (cdr (assoc :results params)))
	 (results (if (stringp results) (split-string results) nil)))
    (cond
     ((member "table" results) 'table)
     ((member "matrix" results) 'matrix)
     ((member "raw" results) 'raw)
     (t 'auto))))

(defun ob-julia-check-trueness (params param)
  "" 
  (and (assoc param params)
   (let ((val (cdr (assoc param params))))
     (or
      (not val)
      (string= "t" val)
      (string= "yes" val)))))

(defun org-babel-julia-async-p (params)
  "Check whether the session should be async or not."
  (let* ((res (cdr (assoc :results params)))
	 (async (assoc :async params)))
    (and async
	 (ob-julia-check-trueness params :async)
	 (and (eq org-babel-current-src-block-location (org-babel-where-is-src-block-head)))
	 (not (and res (stringp res) (member "silent" (split-string res)))))))

(defun org-babel-julia-really-async-p ()
  (not (bound-and-true-p org-export-current-backend)))

;; Copied from ob-python
(defun org-babel-julia-with-earmuffs (session)
  (let ((name (if (stringp session) session (format "%s" session))))
    (if (and (string= "*" (substring name 0 1))
	     (string= "*" (substring name (- (length name) 1))))
	name
      (format "*%s*" name))))

(defun org-babel-julia-get-inline-type (params)
  "Parse the :inline header from PARAMS.
Returns t, nil or the output format."
  (let ((inlined (assoc :inline params)))
    (if inlined
	(if (and
	     (cdr inlined)
	     (not (string= (cdr inlined) "no")))
	    (cdr inlined)
	  (if (bound-and-true-p org-export-current-backend)
	      (format "%s" org-export-current-backend)
	    nil))
      nil)))

(defun org-babel-execute:julia (body params)
  "Execute a block of julia code.
This function is called by `org-babel-execute-src-block'.
BODY is the content of the src block
PARAMS are the parameter passed to the block"
  ;; org-babel-current-src-block-location ; this variable does not work >.<
  (save-excursion
    (let* ((buffer (buffer-name))
	   (session (org-babel-julia-get-session-name params))
	   (async (org-babel-julia-async-p params))
	   (file (cdr (assoc :file params)))
	   (inlined (org-babel-julia-get-inline-type params))
	   (outfile (org-babel-process-file-name
		     (if file (concat default-directory file)
		       (org-babel-temp-file
			"julia-" (if inlined (format ".%s" inlined) "")))))
	   (src (make-temp-file "ob-julia" nil ".jl" body))
	   (block (org-babel-julia-block-expand params src outfile)))
      (when org-babel-julia-debug (message block))
      (if session
	  (progn
	    ;; TODO: check if session exists, if it does, make it like
	    ;; *session:$N* (where N is the first number available)
	    (setq session (org-babel-julia-with-earmuffs session))
	    (when (not (org-babel-comint-buffer-livep session))
	      (org-babel-prep-session:julia session params))
	    (if (and async
		     (org-babel-julia-really-async-p))
		(progn
		  (when org-babel-julia-debug (message "async export"))
		  (org-babel-julia-process-results
		   (org-babel-execute:julia-async buffer session body
						  block outfile params)
		   params))
	      (progn
		(when org-babel-julia-debug (message "sync export"))
		(org-babel-julia-process-results
		 (org-babel-execute:julia-sync session body block outfile
					       params)
		 params))))
	(let ((res (org-babel-julia-evaluate-external-process
		    block outfile params buffer)))
	  (if (and async (org-babel-julia-really-async-p))
	      res
	    (org-babel-julia-process-results res params)))))))

(add-to-list 'org-babel-tangle-lang-exts '("julia" . "jl"))

(provide 'ob-julia)
;;; ob-julia.el ends here
