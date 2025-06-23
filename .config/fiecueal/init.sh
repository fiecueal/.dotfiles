#!/usr/bin/bash

cd $HOME # start script in home dir
sudo ufw enable
sudo apt purge -y \
gucharmap \
nodejs \
npm \
xfce4-xapp-status-plugin \
yt-dlp

mkdir -p Projects Tools/deno
sudo mkdir -p /opt/dragonruby/zips /opt/godot
sudo mv $HOME/.config/fiecueal/godot.svg /opt/godot/

# Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Victor Mono
wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip -P $HOME/Downloads/
unzip $HOME/Downloads/VictorMonoAll.zip -d $HOME/Downloads/VictorMonoAll/
cp -rT $HOME/Downloads/VictorMonoAll/OTF/ $HOME/.local/share/fonts/

# Sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
wget https://packagecontrol.io/Package%20Control.sublime-package -P $HOME/.config/sublime-text/Installed\ Packages

# yt-dlp
sudo mkdir /opt/yt-dlp
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /opt/yt-dlp/yt-dlp
sudo chmod a+rx /opt/yt-dlp/yt-dlp

# deno
curl -fsSL https://deno.land/install.sh | DENO_INSTALL="$HOME/Tools/deno" sh
ln -s $HOME/Tools/deno/bin/deno $HOME/.local/bin/deno

# pnpm, node
curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm env use --global lts

# go
version=$(curl -s https://go.dev/VERSION?m=text | head -1)
wget https://go.dev/dl/$version.linux-amd64.tar.gz
sudo rm -rf /opt/go && sudo tar -C /opt -xzf $version.linux-amd64.tar.gz
rm $version.linux-amd64.tar.gz

# java 21
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^UBUNTU_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list

sudo git clone https://github.com/git-cola/git-cola /opt/git-cola
# git clone https://github.com/fiecueal/qmk_firmware

# install packages
sudo apt install -y nala
sudo nala fetch --auto --fetches 3 -y
sudo nala upgrade -y
sudo nala install -y \
autojump \
brave-browser \
cowsay \
fcitx5 \
fcitx5-mozc \
ffmpeg \
flameshot \
foliate \
font-manager \
font-viewer \
fonts-3270 \
fonts-anonymous-pro \
fonts-comfortaa \
fonts-klee \
fonts-monofur \
fonts-monoid* \
fonts-noto \
fortunes \
gpick \
i3 \
imagemagick \
inkscape \
mpv \
mypaint \
obs-studio \
pavucontrol \
playerctl \
rofi \
ruby-full \
steam-installer \
sublime-merge \
sublime-text \
temurin-21-jdk \
thunar \
trash-cli \
woff2 \
xsct \
xfce4-terminal

# install flatpaks
flatpak install -y flathub \
com.atlauncher.ATLauncher \
com.github.tchx84.Flatseal \
com.heroicgameslauncher.hgl \
com.tomjwatson.Emote \
io.mgba.mGBA \
net.lutris.Lutris \
com.vysp3r.ProtonPlus

# install tlp for power management and charge thresholds if 'laptop' passed as arg
if [[ $1 == "laptop" ]]; then
  sudo nala install -y tlp
  sudo mkdir -p /etc/tlp.d
  sudo cp $HOME/.config/fiecueal/00-charge-thresh.conf \
          $HOME/.config/fiecueal/00-low-power-cpu.conf \
          /etc/tlp.d/
  sudo tlp start
fi

sudo gem install solargraph

# setup firefox profiles
cd $HOME/.mozilla/firefox
mv $(find -name *.default-release) fiecueal.p1
cp -r fiecueal.p1 fiecueal.p5
cp -r fiecueal.p1 fiecueal.p9

install=$(grep "\[.*\]" installs.ini)
sed -i "1i[Install$(echo $install | cut -c2-)" profiles.ini
cat > installs.ini <<EOF
$install
Default=fiecueal.p1
Locked=1
EOF

cd $HOME/Projects
git clone https://github.com/fiecueal/Betterfox
cd Betterfox
./install.sh p1
./install.sh p5
./install.sh p9
cd $HOME

# fix screen tearing & disable mouse acceleration
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp $HOME/.config/fiecueal/20-screentear.conf \
        $HOME/.config/fiecueal/20-mouseaccel.conf \
        /etc/X11/xorg.conf.d/

# fix 8bitdo controller recognition
sudo mkdir -p /etc/udev/rules.d/ /etc/modules-load.d/
sudo cp $HOME/.config/fiecueal/71-8bitdo-controllers.rules /etc/udev/rules.d/
sudo cp $HOME/.config/fiecueal/uinput.conf /etc/modules-load.d/uinput.conf

# shutdown on power button held instead of pressed
sudo mkdir -p /etc/systemd/logind.conf.d
sudo cp $HOME/.config/fiecueal/20-powerbutton.conf /etc/systemd/logind.conf.d/

cat <<EOF
Not yet done:
* Download Dragonruby
* Download Godot
* Download Grayjay
* Download Intellij Idea
* Monospacify monofur font
* Install firefox extensions
EOF
