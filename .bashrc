# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# PS1='\[\033[1;33m\]\w\[\033[00m\]\$ '
PS1='\[\e[33;1m\][\W]\[\e[0m\] '
PS2='\[\e[33;1;7m\]>\[\e[0m\] '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# exports & aliases
export PATH=$PATH:$HOME/.local/share/pnpm
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/intellij2024.1.1/bin
export DOTNET_CLI_TELEMETRY_OPTOUT=true

alias dlp='yt-dlp -f "bv*+ba/b"'
alias dlp720='yt-dlp -f "bv*[height<=720]+ba/b[height<=720]"'
alias ls='ls -A --color=auto'
alias path='echo $PATH | tr ":" "\n"'
alias pn='pnpm'
alias pnx='pnpm dlx'

if [ -e ~/.dotfiles ]; then
  alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
elif [ -e ~/.dotfiles.git ]; then
  alias config='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
else
  echo -e '\e[1;7m
********************************************
***                                      ***
***  .dotfiles bare repo does not exist  ***
***                                      ***
********************************************
\e[0m'
fi

# autojump
. /usr/share/autojump/autojump.bash

fortune | cowsay

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
