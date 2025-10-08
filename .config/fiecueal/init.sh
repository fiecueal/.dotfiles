#!/usr/bin/bash

is_server=false
is_laptop=false

for arg in "$@"; do
  case "$arg" in
  server) is_server=true ;;
  laptop) is_laptop=true ;;
  esac
done

cd $HOME
mkdir -p Archives Pictures/screenshots Projects Minecraft .local/bin

sudo mkdir -p /etc/systemd/logind.conf.d
sudo cp $HOME/.config/fiecueal/00-powerkey-lidswitch.conf /etc/systemd/logind.conf.d/

sudo apt purge -y yt-dlp
sudo apt-mark hold yt-dlp
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o .local/bin/yt-dlp
chmod a+rx .local/bin/yt-dlp

sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install -y \
autojump \
btop \
build-essential \
curl \
libgmp-dev \
libssl-dev \
libyaml-dev \
micro \
network-manager \
nnn \
openjdk-21-jdk-headless \
rustc \
tar \
trash-cli \
ufw \
unzip \
wget \
zip \
zlib1g-dev \

curl https://mise.run | sh
eval "$(mise activate)"
mise use -g go@latest
mise use -g ruby@latest

gem install rails

if $is_server; then

sudo apt install -y \
nfs-kernel-server \
openssh-server \
samba \

sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.old
sudo cp $HOME/.config/fiecueal/smb.conf /etc/samba/smb.conf
sudo systemctl restart smbd nmbd

sudo mkdir -p /srv/nfs
sudo chown nobody:nogroup /srv/nfs
sudo chmod 777 /srv/nfs
echo '/srv/nfs 10.0.0.0/24(rw,sync,no_subtree_check)' | sudo tee -a /etc/exports
sudo exportfs -ra

PORT=$(ruby -e "puts rand(32768..60999)")
echo $PORT > Minecraft/port.txt

sudo ufw allow from 10.0.0.0/24 to any app SSH
sudo ufw allow from 10.0.0.0/24 to any app Samba
sudo ufw allow from 10.0.0.0/24 to any app NFS
sudo ufw allow ${PORT}/tcp

else # client

cd $HOME/.config/fiecueal

sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp 20-screentear.conf 20-mouseaccel.conf /etc/X11/xorg.conf.d/

sudo mkdir -p /etc/udev/rules.d/ /etc/modules-load.d/
sudo cp 71-8bitdo-controllers.rules /etc/udev/rules.d/
sudo cp uinput.conf /etc/modules-load.d/uinput.conf

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
wget https://github.com/wbond/package_control/releases/latest/download/Package.Control.sublime-package -P $HOME/.config/sublime-text/Installed\ Packages
cd $HOME/.config/sublime-text/Installed\ Packages
mv Package.Control.sublime-package Package\ Control.sublime-package

ln -s $DRAGONRUBY_HOME/dragonruby $HOME/.local/bin/dragonruby
ln -s $DRAGONRUBY_HOME/dragonruby-httpd $HOME/.local/bin/dragonruby-httpd
ln -s $DRAGONRUBY_HOME/dragonruby-publish $HOME/.local/bin/dragonruby-publish

wget https://github.com/godotengine/godot/releases/download/4.5-stable/Godot_v4.5-stable_linux.x86_64.zip
unzip Godot_v4.5-stable_linux.x86_64.zip
mv Godot_v4.5-stable_linux.x86_64 $HOME/.local/bin/godot
rm Godot_v4.5-stable_linux.x86_64.zip

curl -fsSL https://deno.land/install.sh | sh
ln -s $DENO_ISNTALL/bin/deno $HOME/.local/bin/deno

curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm env use --global lts

# git clone https://github.com/fiecueal/qmk_firmware

sudo apt install -y \
brave-browser \
cowsay \
dunst \
fcitx5 \
fcitx5-mozc \
ffmpeg \
firefox-esr \
flameshot \
flatpak \
foliate \
font-manager \
font-viewer \
fonts-3270 \
fonts-klee \
fonts-monofur \
fonts-noto \
fortunes \
git-cola \
gpick \
gpicview \
i3-wm \
i3lock \
imagemagick \
inkscape \
libglib2.0-bin \
mpv \
mtpaint \
network-manager-applet \
nfs-common \
obs-studio \
openssh-client \
pavucontrol \
playerctl \
pulseaudio \
steam-installer \
sublime-merge \
sublime-text \
suckless-tools \
thunar \
udisks2 \
woff2 \
xdg-utils \
xfce4-clipman \
xfce4-terminal \
xinit \
xsct \
xss-lock \

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub \
com.atlauncher.ATLauncher \
com.github.tchx84.Flatseal \
com.heroicgameslauncher.hgl \
com.tomjwatson.Emote \
com.vysp3r.ProtonPlus \
net.lutris.Lutris \

cd $HOME/.mozilla/firefox
mv $(find -name *.default) fiecueal.p1
cp -r fiecueal.p1 fiecueal.p5
cp -r fiecueal.p1 fiecueal.p9

mv profiles.ini profiles.ini.old
cp $HOME/.config/fiecueal/profiles.ini .

sed -i "1i$(grep "\[Install.*\]" profiles.ini.old)" profiles.ini
sed -i "s/^Default=.*$/Default=fiecueal.p1/" installs.ini

cd $HOME/Projects
git clone https://github.com/fiecueal/Betterfox
cd Betterfox
./install.sh p1
./install.sh p5
./install.sh p9

fi # $is_server

sudo ufw enable

if $is_laptop; then
sudo apt install -y tlp
sudo mkdir -p /etc/tlp.d
sudo cp $HOME/.config/fiecueal/00-charge-thresh.conf \
        $HOME/.config/fiecueal/00-low-power-cpu.conf \
        /etc/tlp.d/
sudo tlp start
fi

cat <<EOF
Not yet done:
* Download Dragonruby
* Download Grayjay
* Download Intellij Idea
* Monospacify monofur font
* Install firefox extensions
* Add samba users
* Share nfs
* Reboot
EOF
