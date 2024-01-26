CC0 [Monogram](https://datagoblin.itch.io/monogram) font located in `.local/share/fonts`

Needs to be manually installed(a.k.a. idk how to install latest vers from cli ¯\\\_(ツ)\_/¯):
- [Godot](https://godotengine.org/download/linux)
- [Dragonruby](https://dragonruby.itch.io/dragonruby-gtk)

Godot binary needs to be renamed to `godot` and moved to `.local/bin` (or anywhere in path) so the desktop file actually
works

`init.sh` does:
1. install nala
1. remove yt-dlp to install a newer version
1. install fonts
1. add sources for sublime, node, npm
1. install pnpm, yt-dlp, go
1. install packages
1. install flatpaks
1. install tlp and xbacklight if "laptop" is passed as arg
1. turn on ufw
1. download package control sublime package (auto installs other packages on sublime startup)
1. install solargraph ruby gem
1. set xfce4-terminal as default terminal
1. set fcitx as imf
1. rempove screentear
1. change power button function(press = nothing, hold = turn off)

### TODO:
- add jp to fcitx input method list
- write a script to control backlight brightness
-
