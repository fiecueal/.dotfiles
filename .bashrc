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

PS1='\[\e[33;1;7m\]\W $\[\e[0m\] '
PS2='\[\e[33;1;7m\]\W >\[\e[0m\] '

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

alias dlp='yt-dlp -f "bv*+ba/b"'
alias dlp720='yt-dlp -f "bv*[height<=720]+ba/b[height<=720]"'
alias ls='ls -A --color=auto'
alias ll='ls -Ahl --color=auto'
alias path='echo $PATH | tr ":" "\n"'
alias pn='pnpm'
alias drun='dragonruby $(pwd)'
alias config='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

export PNPM_HOME="$HOME/.local/pnpm"
export DENO_INSTALL="$HOME/.local/deno"
export DRAGONRUBY_HOME="$HOME/.local/dragonruby"

mkcd() {
  mkdir -p "$1"
  cd "$1"
  pwd
}

drinit() {
  if [ -z "$1" ]; then
    echo "FAILED: No directory name supplied"
  elif [ -d "$HOME/Projects/$1" ]; then
    echo "FAILED: $1 directory already exists"
  else
    cp -r $DRAGONRUBY_HOME/mygame "$HOME/Projects/$1"
    cd "$HOME/Projects/$1"
    echo "New project created at: $HOME/Projects/$1"
  fi
}

drupgrade() {
  zip="${1:-$HOME/Downloads/dragonruby-gtk-linux-amd64.zip}"
  ziptype=$(file -b --mime-type $zip)
  if [ $ziptype != "application/zip" ]; then
    echo "FAILED: $zip is not a zip file"
  else
    unzip $zip
    rm .itch.toml
    version=$(dragonruby-linux-amd64/dragonruby version)
    mv $zip $HOME/.local/dragonruby-zips/$version
    rm -rf $DRAGONRUBY_HOME
    mv dragonruby-linux-amd64 $DRAGONRUBY_HOME
  fi
}

# autojump
. /usr/share/autojump/autojump.bash

fortune | cowsay
