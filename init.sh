#!/usr/bin/bash

# nala
sudo apt install -y nala
sudo nala fetch --auto --fetches 3 -y
sudo nala upgrade -y

# remove unwanted programs
sudo nala purge -y yt-dlp gucharmap

# fonts
# Victor Mono
wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip -P ~/Downloads/
unzip ~/Downloads/VictorMonoAll.zip -d ~/Downloads/VictorMonoAll/
cp -rT ~/Downloads/VictorMonoAll/OTF/ ~/.local/share/fonts/
# Klee One
wget https://github.com/fontworks-fonts/Klee/raw/master/fonts/ttf/KleeOne-Regular.ttf -P ~/.local/share/fonts
wget https://github.com/fontworks-fonts/Klee/raw/master/fonts/ttf/KleeOne-SemiBold.ttf -P ~/.local/share/fonts
# IBM 3270 nerd font
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/3270.zip -P ~/Downloads/
unzip ~/Downloads/3270.zip -d ~/Downloads/3270/
cp ~/Downloads/3270/*.ttf ~/.local/share/fonts/

# icons
# Nordzy
git clone https://github.com/alvatip/Nordzy-icon
cd Nordzy-icon
./install.sh
cd

# Sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# yt-dlp
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

# nodejs & npm
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=21
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# pnpm (open new terminal to use)
curl -fsSL https://get.pnpm.io/install.sh | sh -

# go
version=$(curl -s https://go.dev/VERSION?m=text | head -1)
wget https://go.dev/dl/$version.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $version.linux-amd64.tar.gz

# install packages
sudo nala install -y \
autojump \
breeze-gtk-theme \
cowsay \
fcitx \
fcitx-mozc \
ffmpeg \
flameshot \
foliate \
font-manager \
fonts-noto \
fortunes \
git-cola \
gpick \
i3 \
im-config \
imagemagick \
inkscape \
nodejs \
pavucontrol \
redshift \
redshift-gtk \
rofi \
ruby-full \
simplescreenrecorder \
sublime-text \
woff2 \
xbacklight \
xclip \
xfce4-terminal \

# install tlp for power management and charge thresholds if 'laptop' passed as arg
if [[ $1 == "laptop" ]]; then

sudo nala install -y tlp
sudo mkdir -p /etc/tlp.d
sudo bash -c 'cat > /etc/tlp.d/00-charge-thresh.conf <<EOF
START_CHARGE_THRESH_BAT0=0
STOP_CHARGE_THRESH_BAT0=60
EOF'
tlp start

fi

# firewall
sudo ufw enable

# ruby gems
sudo gem install solargraph

# set xfce4-terminal as default
sudo update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper
gsettings set org.cinnamon.desktop.default-applications.terminal exec xfce4-terminal

# TODO: add mozc to active input methods
# im-config
im-config -n fcitx

# fix screen tearing
sudo mkdir -p /etc/X11/xorg.conf.d
sudo bash -c '
cat > /etc/X11/xorg.conf.d/20-tearfree.conf <<EOF
Section "OutputClass"
  Identifier "AMD"
  MatchDriver "amdgpu"
  Driver "amdgpu"
  Option "TearFree" "true"
EndSection
Section "OutputClass"
  Identifier "Intel Graphics"
  Driver "intel"
  Option "TearFree" "true"
EndSection
EOF
'

# for accidental clicks of power switch(especially on laptops)
sudo mkdir -p /etc/systemd/logind.conf.d
sudo bash -c '
cat > /etc/systemd/logind.conf.d/20-powerbutton.conf <<EOF
HandlePowerKey=ignore
HandlePowerKeyLongPress=poweroff
EOF
'
