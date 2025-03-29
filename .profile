# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

PATH="/opt/dragonruby/main:$PATH"
PATH="/opt/git-cola/bin:$PATH"
PATH="/opt/go/bin:$PATH"
PATH="/opt/godot/main:$PATH"
PATH="/opt/intellij-idea/main/bin:$PATH"
PATH="/opt/yt-dlp:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/Tools/pnpm:$PATH"
