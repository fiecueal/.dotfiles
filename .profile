umask 022

PATH=$(printf "$HOME/.local/pnpm
$HOME/.local/bin
/opt/intellij-idea/bin
/opt/odin
/usr/local/sbin
/usr/local/bin
/usr/sbin
/usr/bin
/sbin
/bin
/usr/local/games
/usr/games" | tr "\n" ":")

. "$HOME/.bashrc"

case "$(tty)" in
"/dev/tty1") pgrep i3 || exec startx $HOME/.config/X11/xinitrc ;;
esac
