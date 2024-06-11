#!/usr/bin/bash

sudo ufw enable
sudo apt purge -y yt-dlp gucharmap nodejs npm

# Nord theme stuff
mkdir -p $HOME/.local/share/themes
git clone https://github.com/EliverLara/Nordic-Polar.git $HOME/.local/share/themes/Nordic-Polar
git clone https://github.com/alvatip/Nordzy-icon
cd Nordzy-icon
./install.sh
cd

# fonts
# Victor Mono
wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip -P $HOME/Downloads/
unzip $HOME/Downloads/VictorMonoAll.zip -d $HOME/Downloads/VictorMonoAll/
cp -rT $HOME/Downloads/VictorMonoAll/OTF/ $HOME/.local/share/fonts/
# Klee One
wget https://github.com/fontworks-fonts/Klee/raw/master/fonts/ttf/KleeOne-Regular.ttf -P $HOME/.local/share/fonts
wget https://github.com/fontworks-fonts/Klee/raw/master/fonts/ttf/KleeOne-SemiBold.ttf -P $HOME/.local/share/fonts

# Sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# yt-dlp
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $HOME/.local/bin/yt-dlp
chmod a+rx $HOME/.local/bin/yt-dlp

# nodejs & npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install 22

# go
version=$(curl -s https://go.dev/VERSION?m=text | head -1)
wget https://go.dev/dl/$version.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $version.linux-amd64.tar.gz
rm $version.linux-amd64.tar.gz

git clone https://github.com/odin-lang/Odin
git clone https://github.com/git-cola/git-cola

# install packages
sudo apt install -y nala
sudo nala fetch --auto -c US --fetches 3 -y
sudo nala upgrade -y
sudo nala install -y \
autojump \
breeze-gtk-theme \
clang \
cowsay \
fcitx \
fcitx-mozc \
ffmpeg \
flameshot \
font-manager \
fonts-3270 \
fonts-noto \
fortunes \
gpick \
i3 \
i3status \
im-config \
imagemagick \
inkscape \
llvm \
mypaint \
pavucontrol \
playerctl \
python3-qtpy \
redshift \
redshift-gtk \
rofi \
ruby-full \
sublime-text \
trash-cli \
woff2 \
xfce4-terminal \
xsct \

# install flatpaks
flatpak install -y flathub \
com.atlauncher.ATLauncher \
com.github.johnfactotum.Foliate \
com.github.tchx84.Flatseal \
com.heroicgameslauncher.hgl \
com.obsproject.Studio \
com.tomjwatson.Emote \
io.mgba.mGBA \
org.pitivi.Pitivi \
xyz.xclicker.xclicker \

# install tlp for power management and charge thresholds if 'laptop' passed as arg
if [[ $1 == "laptop" ]]; then
  sudo nala install -y tlp xbacklight
  sudo mkdir -p /etc/tlp.d
  sudo bash -c 'cat > /etc/tlp.d/00-charge-thresh.conf <<EOF
START_CHARGE_THRESH_BAT0=0
STOP_CHARGE_THRESH_BAT0=60
EOF'
  sudo tlp start
  xbacklight set 100
fi

sudo npm i -g pnpm
make -C Odin/
sudo gem install solargraph rufo ruby-lsp
wget https://packagecontrol.io/Package%20Control.sublime-package -P $HOME/.config/sublime-text/Installed\ Packages

sudo update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper
gsettings set org.cinnamon.desktop.default-applications.terminal exec xfce4-terminal

# TODO: add mozc to active input methods
im-config -n fcitx

# fix screen tearing & disable mouse acceleration
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp $HOME/init-confs/20-screentear.conf \
$HOME/init-confs/20-mouseaccel.conf \
/etc/X11/xorg.conf.d/
# for accidental clicks of power switch(especially on laptops)
sudo mkdir -p /etc/systemd/logind.conf.d
sudo cp $HOME/init-confs/20-powerbutton.conf /etc/systemd/logind.conf.d/
