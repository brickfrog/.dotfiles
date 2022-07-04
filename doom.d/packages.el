;; -*- no-byte-compile: t; -*-

;; [[file:config.org::*Rotate (window management)][Rotate (window management):1]]
(package! rotate :pin "4e9ac3ff800880bd9b705794ef0f7c99d72900a6")
;; Rotate (window management):1 ends here

;; [[file:config.org::*Conda][Conda:1]]
(package! conda)
;; Conda:1 ends here

;; [[file:config.org::*Very large files][Very large files:1]]
;;(package! vlf :recipe (:host github :repo "m00natic/vlfi" :files ("*.el"))
;;  :pin "cc02f2533782d6b9b628cec7e2dcf25b2d05a27c" :disable t)
;; Very large files:1 ends here

;; [[file:config.org::*EVIL][EVIL:2]]
; (package! evil-escape :disable t/) ; Disabling the package if needed
(setq-default evil-escape-key-sequence "jk")
;; EVIL:2 ends here

;; [[file:config.org::*Magit delta][Magit delta:2]]
;; (package! magit-delta :recipe (:host github :repo "dandavison/magit-delta") :pin "56cdffd377279589aa0cb1df99455c098f1848cf")
;; Magit delta:2 ends here

;; [[file:config.org::*Auto activating snippets][Auto activating snippets:1]]
(package! aas :recipe (:host github :repo "ymarco/auto-activating-snippets")
  :pin "566944e3b336c29d3ac11cd739a954c9d112f3fb")
;; Auto activating snippets:1 ends here

;; [[file:config.org::*Screenshot][Screenshot:1]]
(package! screenshot :recipe (:local-repo "lisp/screenshot"))
;; Screenshot:1 ends here

;; [[file:config.org::*Etrace][Etrace:1]]
(package! etrace :recipe (:host github :repo "aspiers/etrace")
  :pin "2291ccf2f2ccc80a6aac4664e8ede736ceb672b7")
;; Etrace:1 ends here

;; [[file:config.org::*Etrace][Etrace:2]]
(use-package! etrace
  :after elp)
;; Etrace:2 ends here

;; [[file:config.org::*String inflection][String inflection:1]]
(package! string-inflection :pin "fd7926ac17293e9124b31f706a4e8f38f6a9b855")
;; String inflection:1 ends here

;; [[file:config.org::*Info colours][Info colours:1]]
(package! info-colors :pin "47ee73cc19b1049eef32c9f3e264ea7ef2aaf8a5")
;; Info colours:1 ends here

;; [[file:config.org::*Modus themes][Modus themes:1]]
(package! modus-themes :pin "810a035768085167440c07f99bd7b64e6894d1b7")
;; Modus themes:1 ends here

;; [[file:config.org::*Theme magic][Theme magic:1]]
(package! theme-magic :pin "844c4311bd26ebafd4b6a1d72ddcc65d87f074e3")
;; Theme magic:1 ends here

;; [[file:config.org::*Keycast][Keycast:1]]
(package! keycast :pin "72d9add8ba16e0cae8cfcff7fc050fa75e493b4e")
;; Keycast:1 ends here

;; [[file:config.org::*Screencast][Screencast:1]]
(package! gif-screencast :pin "5517a557a17d8016c9e26b0acb74197550f829b9")
;; Screencast:1 ends here

;; [[file:config.org::*Prettier page breaks][Prettier page breaks:1]]
(package! page-break-lines :recipe (:host github :repo "purcell/page-break-lines")
  :pin "cc283621c64e4f1133a63e0945658a4abecf42ef")
;; Prettier page breaks:1 ends here

;; [[file:config.org::*Selectric][Selectric:1]]
(package! selectric-mode :pin "1840de71f7414b7cd6ce425747c8e26a413233aa")
;; Selectric:1 ends here

;; [[file:config.org::*Wttrin][Wttrin:1]]
(package! wttrin :recipe (:local-repo "lisp/wttrin"))
;; Wttrin:1 ends here

;; [[file:config.org::*Spray][Spray:1]]
(package! spray :pin "74d9dcfa2e8b38f96a43de9ab0eb13364300cb46")
;; Spray:1 ends here

;; [[file:config.org::*Elcord][Elcord:1]]
(package! elcord :pin "70fd716e673b724b30b921f4cfa0033f9c02d0f2")
;; Elcord:1 ends here

;; [[file:config.org::*Systemd][Systemd:1]]
(package! systemd :pin "b6ae63a236605b1c5e1069f7d3afe06ae32a7bae")
;; Systemd:1 ends here

;; [[file:config.org::*Ebooks][Ebooks:1]]
(package! calibredb :pin "232fa1cf3af08200af439d1cbb5a131f38286183")
;; Ebooks:1 ends here

;; [[file:config.org::*Ebooks][Ebooks:2]]
(package! nov :pin "8f5b42e9d9f304b422c1a7918b43ee323a7d3532")
;; Ebooks:2 ends here

;; [[file:config.org::*CalcTeX][CalcTeX:1]]
(package! calctex :recipe (:host github :repo "johnbcoughlin/calctex"
                           :files ("*.el" "calctex/*.el" "calctex-contrib/*.el" "org-calctex/*.el" "vendor"))
  :pin "67a2e76847a9ea9eff1f8e4eb37607f84b380ebb")
;; CalcTeX:1 ends here

;; [[file:config.org::*Setup][Setup:2]]
(package! elfeed-tube :recipe (:host github :repo  "karthink/elfeed-tube"))
(package! aio)
;; Setup:2 ends here

;; [[file:config.org::*Scoring][Scoring:1]]
(package! elfeed-score)
;; Scoring:1 ends here

(package! org-mode :recipe (:host github :repo "emacs-straight/org-mode" :files ("*.el" "lisp/*.el" "etc") :pre-build (with-temp-file (doom-path (straight--repos-dir "org-mode") "org-version.el") (insert "(fset 'org-release (lambda () \"9.5\"))
" (format "(fset 'org-git-version (lambda () \"%s\"))
" (substring (shell-command-to-string "git rev-parse --short HEAD") 0 -1)) "(provide 'org-version)
")) :includes org) :pin nil)
(unpin! org-mode) ; there be bugs
(package! org-contrib
  :recipe (:host nil :repo "https://git.sr.ht/~bzg/org-contrib"
           :files ("lisp/*.el"))
  :pin "15b03d5090cd6ef46bdfdd14a3f9e20c3dab60da")

(package! org-modern :pin "b352680d9ee8c6e6966cc21d595513c3595e3bb7")

(after! spell-fu
  (cl-pushnew 'org-modern-tag (alist-get 'org-mode +spell-excluded-faces-alist)))

(package! org-appear :recipe (:host github :repo "awth13/org-appear")
  :pin "8dd1e564153d8007ebc4bb4e14250bde84e26a34")

(package! org-ol-tree :recipe (:host github :repo "Townk/org-ol-tree")
  :pin "207c748aa5fea8626be619e8c55bdb1c16118c25")

(package! ob-julia :recipe (:local-repo "lisp/ob-julia" :files ("*.el" "julia")))

(package! ob-http :pin "b1428ea2a63bcb510e7382a1bf5fe82b19c104a7")

(package! org-transclusion :recipe (:host github :repo "nobiot/org-transclusion")
  :pin "ccc0aaa72732ea633bf52bcc8a0345cd3ac178fd")

(package! pdf-view-restore)

(package! org-graph-view :recipe (:host github :repo "alphapapa/org-graph-view") :pin "233c6708c1f37fc60604de49ca192497aef39757")

(package! org-chef :pin "6a786e77e67a715b3cd4f5128b59d501614928af")

(package! org-pandoc-import :recipe
  (:local-repo "lisp/org-pandoc-import" :files ("*.el" "filters" "preprocessors")))

(package! orgdiff :recipe (:local-repo "lisp/orgdiff"))

(package! org-music :recipe (:local-repo "lisp/org-music"))

(package! citar :pin "d55cac7a2b8b848990ebd713de8667bf3fe93c6b")
(package! citeproc :pin "ba49516265fa24b138346c4918d39d19b4de8a62")
(package! org-cite-csl-activate :recipe (:host github :repo "andras-simonyi/org-cite-csl-activate") :pin "4fdb61c0f83b5d6db0d07dfd64d2a177fd46e931")

(package! org-super-agenda :pin "3108bc3f725818f0e868520d2c243abe9acbef4e")

(package! doct
  :recipe (:host github :repo "progfolio/doct")
  :pin "4033a8fd8681d3989550f7a2532d6b4e3c45bfe8")

(package! org-roam-ui :recipe (:host github :repo "org-roam/org-roam-ui" :files ("*.el" "out")) :pin "9474a254390b1e42488a1801fed5826b32a8030b")
(package! websocket :pin "82b370602fa0158670b1c6c769f223159affce9b") ; dependency of `org-roam-ui'

;; (package! org-pretty-tags :pin "5c7521651b35ae9a7d3add4a66ae8cc176ae1c76")

(package! org-fragtog :pin "680606189d5d28039e6f9301b55ec80517a24005")

(package! engrave-faces :recipe (:local-repo "lisp/engrave-faces"))

(package! ox-chameleon :recipe (:local-repo "lisp/ox-chameleon"))

(package! ox-gfm :pin "99f93011b069e02b37c9660b8fcb45dab086a07f")

;; [[file:config.org::*LAAS][LAAS:1]]
(package! laas :recipe (:local-repo "lisp/LaTeX-auto-activating-snippets"))
;; LAAS:1 ends here

;; [[file:config.org::*Graphviz][Graphviz:1]]
(package! graphviz-dot-mode :pin "6e96a89762760935a7dff6b18393396f6498f976")
;; Graphviz:1 ends here

;; [[file:config.org::*Beancount][Beancount:1]]
(package! beancount :recipe (:host github :repo "beancount/beancount-mode")
  :pin "ea8257881b7e276e8d170d724e3b2e179f25cb77")
;; Beancount:1 ends here
