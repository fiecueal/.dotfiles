#!/usr/bin/bash

cd $HOME # start script in home dir
sudo ufw enable
sudo apt purge -y \
gucharmap \
nodejs \
npm \
xfce4-xapp-status-plugin \
yt-dlp

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
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $HOME/.local/bin/yt-dlp
chmod a+rx $HOME/.local/bin/yt-dlp

# nodejs, npm, pnpm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node
npm i -g pnpm

# go
version=$(curl -s https://go.dev/VERSION?m=text | head -1)
wget https://go.dev/dl/$version.linux-amd64.tar.gz
sudo rm -rf /opt/go && sudo tar -C /opt -xzf $version.linux-amd64.tar.gz
rm $version.linux-amd64.tar.gz

# java 21
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^UBUNTU_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list

# intellij idea
# TODO: check for latest version
version='2024.2.3'
wget https://download-cdn.jetbrains.com/idea/ideaIC-$version.tar.gz
sudo tar -xzf ideaIC-$version.tar.gz --strip-components=1 --one-top-level="/opt/idea-ce-$version"
rm ideaIC-$version.tar.gz

sudo git clone https://github.com/git-cola/git-cola /opt/git-cola
git clone https://github.com/fiecueal/qmk_firmware

# install packages
sudo apt install -y nala
sudo nala fetch --auto --fetches 3 -y
sudo nala upgrade -y
sudo nala install -y \
autojump \
brave-browser \
clang-18 \
cowsay \
fcitx5 \
fcitx5-mozc \
ffmpeg \
flameshot \
font-manager \
font-viewer \
fonts-3270 \
fonts-klee \
fonts-noto \
fortunes \
gpick \
i3 \
imagemagick \
inkscape \
llvm-18 \
mypaint \
pavucontrol \
pcmanfm \
playerctl \
python3-qtpy \
rofi \
ruby-full \
sublime-text \
temurin-21-jdk \
trash-cli \
woff2 \
xsct \

# odin
sudo git clone https://github.com/odin-lang/Odin /opt/odin
cd /opt/odin
sudo make release-native
cd $HOME

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
  sudo nala install -y tlp
  sudo mkdir -p /etc/tlp.d
  sudo cp $HOME/init-confs/00-charge-thresh.conf \
          $HOME/init-confs/00-low-power-cpu.conf \
          /etc/tlp.d/
  sudo tlp start
fi

sudo gem install solargraph

# fix screen tearing & disable mouse acceleration
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp $HOME/init-confs/20-screentear.conf \
        $HOME/init-confs/20-mouseaccel.conf \
        /etc/X11/xorg.conf.d/

# shutdown on power button held instead of pressed
sudo mkdir -p /etc/systemd/logind.conf.d
sudo cp $HOME/init-confs/20-powerbutton.conf /etc/systemd/logind.conf.d/
