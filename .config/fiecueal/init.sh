#!/usr/bin/bash

set -e

is_server=
is_laptop=

for arg in "$@"; do
  case "$arg" in
  server) is_server=true ;;
  laptop) is_laptop=true ;;
       *) echo "unrecognized arg: $arg" && exit 1
  esac
done

cd $HOME
export PNPM_HOME="$HOME/.local/pnpm"
export DRAGONRUBY_HOME="$HOME/.local/dragonruby"
export PATH="$PNPM_HOME:$PATH"
mkdir -p Archives Pictures/screenshots Projects .local/bin

sudo mkdir -p /etc/systemd/logind.conf.d
sudo cp $HOME/.config/fiecueal/00-powerkey-lidswitch.conf /etc/systemd/logind.conf.d/

sudo apt purge -y yt-dlp
sudo apt-mark hold yt-dlp

sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install --no-install-recommends -y \
autojump \
btop \
curl \
golang \
gpg \
micro \
network-manager \
nnn \
openjdk-21-jdk-headless \
ruby-full \
smartmontools \
tar \
tmux \
trash-cli \
ufw \
unzip \
wget \
zip \

curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o .local/bin/yt-dlp
chmod a+rx .local/bin/yt-dlp

if [ $is_server ]; then

sudo mkdir -p Minecraft/config

sudo apt install --no-install-recommends -y \
nfs-kernel-server \
openssh-server \
samba \

sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.old
sudo cp $HOME/.config/fiecueal/smb.conf /etc/samba/smb.conf
sudo systemctl restart smbd nmbd

sudo mkdir -p /srv/nfs
sudo chown nobody:nogroup /srv/nfs
sudo chmod 777 /srv/nfs
sudo mv /etc/exports /etc/exports.old
echo '/srv/nfs 10.0.0.0/24(rw,sync,no_subtree_check)' | sudo tee /etc/exports
sudo exportfs -ra

# sysctl net.ipv4.ip_local_port_range
PORT=$(ruby -e "puts rand(32768..60999)")
echo $PORT | sudo tee Minecraft/config/port.txt

sudo ufw allow from 10.0.0.0/24 to any app SSH
sudo ufw allow from 10.0.0.0/24 to any app Samba
sudo ufw allow from 10.0.0.0/24 to any app NFS
sudo ufw allow from 10.0.0.0/24 to any port 5678 comment "n8n"
sudo ufw allow ${PORT}/tcp comment "Minecraft"

else # client

cd $HOME/.config/fiecueal

sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp 20-screentear.conf 20-mouseaccel.conf /etc/X11/xorg.conf.d/

sudo mkdir -p /etc/udev/rules.d/ /etc/modules-load.d/
sudo cp 71-8bitdo-controllers.rules /etc/udev/rules.d/
sudo cp uinput.conf /etc/modules-load.d/uinput.conf

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources

mkdir -p $HOME/.config/sublime-text/Installed\ Packages
cd $HOME/.config/sublime-text/Installed\ Packages
wget https://github.com/wbond/package_control/releases/latest/download/Package.Control.sublime-package
mv Package.Control.sublime-package Package\ Control.sublime-package

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

ln -sf $DRAGONRUBY_HOME/dragonruby $HOME/.local/bin/dragonruby
ln -sf $DRAGONRUBY_HOME/dragonruby-httpd $HOME/.local/bin/dragonruby-httpd
ln -sf $DRAGONRUBY_HOME/dragonruby-publish $HOME/.local/bin/dragonruby-publish

wget https://github.com/godotengine/godot/releases/download/4.5-stable/Godot_v4.5-stable_linux.x86_64.zip
unzip Godot_v4.5-stable_linux.x86_64.zip
mv Godot_v4.5-stable_linux.x86_64 $HOME/.local/bin/godot
rm Godot_v4.5-stable_linux.x86_64.zip

curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm env use --global lts

sudo sed -i "s/^deb \S* \w* .*/& contrib/" /etc/apt/sources.list
sudo dpkg --add-architecture i386

# git clone https://github.com/fiecueal/qmk_firmware

sudo apt update
sudo apt install --no-install-recommends -y \
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
fonts-klee \
fonts-monofur \
fonts-noto-* \
fonts-ocr-a \
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
polkitd \
pulseaudio \
steam-installer \
sublime-merge \
sublime-text \
suckless-tools \
thunar \
udisks2 \
wezterm \
woff2 \
xdg-utils \
xfce4-clipman \
xinit \
xsct \
xss-lock \

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub \
com.atlauncher.ATLauncher \
com.github.tchx84.Flatseal \
com.heroicgameslauncher.hgl \
com.tomjwatson.Emote \
com.vysp3r.ProtonPlus \
net.lutris.Lutris \

# assuming setup is from tty & no firefox files are made yet
firefox -CreateProfile p1
cd $HOME/.mozilla/firefox
mv $(find -name *.p1) fiecueal.p1
cp -r fiecueal.p1 fiecueal.p5
cp -r fiecueal.p1 fiecueal.p9

mv profiles.ini profiles.ini.old
cp $HOME/.config/fiecueal/profiles.ini .

sed -i "1i$(grep "\[Install.*\]" profiles.ini.old)" profiles.ini
sed -i "s/^Default=.*$/Default=fiecueal.p1/" installs.ini

cd $HOME/Projects
[ -d Betterfox ] || git clone https://github.com/fiecueal/Betterfox
cd Betterfox
./install.sh p1
./install.sh p5
./install.sh p9

fi # $is_server

sudo ufw --force enable

if [ $is_laptop ]; then
sudo apt install --no-install-recommends -y tlp
sudo mkdir -p /etc/tlp.d
sudo cp $HOME/.config/fiecueal/00-charge-thresh.conf \
        $HOME/.config/fiecueal/00-low-power-cpu.conf \
        /etc/tlp.d/
sudo tlp start
fi

cat <<EOF
Installed: $([ "$is_server" ] && echo server || echo client) $([ "$is_laptop" ] && echo laptop)
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
