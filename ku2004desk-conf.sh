cd Downloads &&\

# Prerequiesites

# canonical-livepatch key
key=()


# @NOTE Ubuntu 20.04
# configure ufw
echo "IPV6=no" >> /etc/ufw/ufw.conf &&\
ufw default deny  incoming &&\
ufw --force enable &&\

# for KDE Connect to work, enable the following ports with UFW
ufwp=("1714:1764/udp" "1714:1764/tcp")  &&\

for g in "${ufwp[@]}"; do
  ufw allow in "${g[@]}";
done &&\


apt -y update && apt -y upgrade && apt -y dist-upgrade && apt -y full-upgrade &&\


# # for Eset
# apt -y install libc6:i386 &&\

# # install eset as simple user
# su iprofor &&\
# chmod 755 eset_nod32av_64bit_en.linux &&\
# ./eset_nod32av_64bit_en.linux
# # go through the GUI steps then reboot
# reboot


# sudo su 
# apt -y update && apt -y upgrade && apt -y dist-upgrade && apt -y full-upgrade &&\
apt -y install ubuntu-restricted-extras &&\


apt -y install dnscrypt-proxy &&\


# Adding external repositories keys
apprepokey=("https://deb.opera.com/archive.key" "https://www.virtualbox.org/download/oracle_vbox_2016.asc" "https://www.virtualbox.org/download/oracle_vbox.asc" "https://download.sublimetext.com/sublimehq-pub.gpg" "https://packages.microsoft.com/keys/microsoft.asc" "https://repo.skype.com/data/SKYPE-GPG-KEY" "https://bintray.com/user/downloadSubjectPublicKey?username=bintray") &&\

for c in "${apprepokey[@]}"; do
  wget -qO- "${c[@]}" | sudo apt-key add -;
done &&\

# Adding external repositories
apprepo=("deb http://archive.canonical.com/ubuntu focal partner" "deb https://deb.opera.com/opera-stable/ stable non-free" "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian focal contrib" "deb https://download.sublimetext.com/ apt/stable/" "ppa:nitrokey/nitrokey" "ppa:serge-rider/dbeaver-ce" "deb [arch=amd64] https://repo.skype.com/deb stable main" "deb https://dl.bintray.com/beekeeper-studio/releases disco main") &&\

for b in "${apprepo[@]}"; do
  add-apt-repository -y "${b[@]}";
done &&\


echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list &&\


apt -y update && apt -y upgrade && apt -y dist-upgrade && apt -y full-upgrade &&\


# unable to locate: rcconf
appcli="asciinema curl dkms exiftool ffmpeg git git-core git-lfs glances htop lm-sensors mc neofetch p7zip p7zip-rar powerline rar screen sysbench terminator testdisk tmux tree unace whois" &&\

# unable to locate: digitalocean-indicator glipper
appgui="beekeeper-studio code gimp gimp-gmic gimp-plugin-registry gmic gparted gramps hexchat inkscape keepassxc nitrokey-app opera-stable pdfchain pdfshuffler skypeforlinux terminator virtualbox-6.1 vlc workrave" &&\

# The main multi-loop for installing apps/libs
for d in $appcli $appgui; do
  apt-get -yqq install $d;
done &&\


apt -y update && apt -y upgrade && apt -y dist-upgrade && apt -y full-upgrade &&\
# Deleting the last two Skype repo entries so that there is no future errors when updating
head -n -2 /etc/apt/sources.list > /etc/apt/sources.list.new &&\
mv /etc/apt/sources.list.new /etc/apt/sources.list &&\
apt -y update && apt -y upgrade && apt -y dist-upgrade && apt -y full-upgrade &&\


# Enabling powerline
# Getting the names of the existed "human" users by looking at the names of the folders (full path) in the /home directory, as well as manually adds the root user to the extracted list
gui_user=$(ls -d -1 /home/** && echo "/root") &&\

# Inserts the powerline commands in .bashrc of the each user found in the /home folder
# @NOTE verify onwer of the .bashrc file
for l in $gui_user; do
echo "if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
    source /usr/share/powerline/bindings/bash/powerline.sh
fi" >> $l/.bashrc;
done &&\


# Asbru Connection Manager
acm=(asbru-cm) &&\
wget -qO- https://packagecloud.io/install/repositories/$acm/$acm/script.deb.sh | sudo bash &&\
apt-get -yqq install $acm &&\

# Install Google Chrome
curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&\
apt -y install --fix-broken ./google-chrome-stable_current_amd64.deb &&\

# snap app installations

# first reboot the OS, logout and login and launch snap for the first time so that on installation of an app one's do ot get a warnning message
snapp="gitkraken slack canonical-livepatch postman" &&\

# The main multi-loop for installing apps/libs
for a in $snapp; do
  snap install --classic $a;
done &&\

# Manual downloading apps
dowapp="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb https://zoom.us/client/latest/zoom_amd64.deb https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn_1.2.3_amd64.deb https://spideroak.com/release/spideroak/deb_x64" &&\

mkdir -p /temp/app && cd $_ &&\
for e in $dowapp; do
  curl -LO $e;
done &&\

mv deb_x64 spideroakone.deb &&\

# The main multi-loop for installing apps/libs
for f in *.deb; do
  apt -y install --fix-broken ./$f;
done &&\


# Register the system on canonical-livepatch service
sudo canonical-livepatch enable $key


su iprofor
chmod +x tresorit_installer.run &&\
sh ./tresorit_installer.run &&\


# installing git lfs widely on the user's workspace
git lfs install &&\


# creating the functionality of saving SSH passhprases in the default KDE Wallet for future use without being prompted for a password. It requires the passhprase only for the first time 
echo -e '#!/bin/sh\r\n/usr/bin/ssh-add $HOME/.ssh/git $HOME/.ssh/server $HOME/.ssh/testing </dev/null\r\nexport SSH_ASKPASS=/usr/bin/ksshaskpass' > ~/.config/autostart-scripts/ssh-add.sh
chmod a+x ~/.config/autostart-scripts/ssh-add.sh
