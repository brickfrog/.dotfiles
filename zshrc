# justin's zsh config

#### ZSH Plugins / Prompts ####

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git auto-notify you-should-use zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh

# bindings for substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# auto notify options
AUTO_NOTIFY_IGNORE+=("lf", "emacs", "kitty")

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#### Program Stuff ####

# adding zoxide
eval "$(zoxide init zsh)"

export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH=~/.local/bin/:~/.local/bin/npm-global/bin:$PATH
export PATH=~/.cargo/bin:$PATH

#### ALIASES ####

alias vim="nvim"
alias v="nvim"
alias hx="helix"
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias ee='emacsclient --eval "(emacs-everywhere)"'

# Speed up scrolling for the document viewer

#### ENV VARIABLES ####

export _JAVA_AWT_WM_NONREPARENTING=1

#### MISCELLANEOUS ####

# Color scheme stuff, using wal or wpg
# (cat $HOME/.config/wpg/sequences &)
# (cat ~/.cache/wal/sequences &)

# printing fortune before each new terminal
fortune -s
printf "\n"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/justin/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/justin/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/justin/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/justin/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
source /usr/share/nvm/init-nvm.sh
