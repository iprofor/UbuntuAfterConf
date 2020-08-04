# Run everything as root excpet where indicated otherwise

# configure the firewall to deny incoming in GUI

dnf update && dnf upgrade

# add epel repo
# dnf update && dnf upgrade

# add the rpmfusion free and non-free repos
rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

rpm -Uvh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable DeltaRPM and Fastest Mirror Plugins
echo "fastestmirror=true 
deltarpm=true" >> /etc/dnf/dnf.conf

dnf update && dnf upgrade


#for Eset
# apt -y install libc6:i386

# +install eset as simple user
# su iprofor
# chmod 755 eset_nod32av_64bit_en.linux
# ./eset_nod32av_64bit_en.linux
# reboot

dnf -y install dnscrypt-proxy
	# configure it
service dnscrypt-proxy start

#  VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

appcli="curl dkms -exiftool ffmpeg git git-core glances htop -lm-sensors mc neofetch p7zip -p7zip-rar p7zip-plugins powerline -rar screen sysbench terminator testdisk tmux tree unace unrar whois";
appgui="code gimp -gimp-gmic -gimp-plugin-registry gmic gparted gramps hexchat inkscape keepassxc nitrokey-app -opera-stable -pdfchain pdfshuffler terminator -virtualbox-6.1 vlc workrave";

# The main multi-loop for installing apps/libs
for d in $appcli $appgui; do
  dnf -y install $d;
done

# Skype
curl -LO https://go.skype.com/skypeforlinux-64.rpm
dnf -y install skypeforlinux-64.rpm

# Asbru Connection Manager
curl -s https://packagecloud.io/install/repositories/asbru-cm/asbru-cm/script.rpm.sh | bash
dnf -y install asbru-cm

# # Enabling powerline
# # Getting the names of the existed "human" users by looking at the names of the folders (full path) in the /home directory, as well as manually adds the root user to the extracted list
# gui_user=$(ls -d -1 /home/** && echo "/root");
# # Inserts the powerline commands in .bashrc of the each user found in the /home folder
# # @NOTE verify onwer of the .bashrc file
# for l in $gui_user; do
# echo "if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
#     source /usr/share/powerline/bindings/bash/powerline.sh
# fi" >> $l/.bashrc;
# done


# Manual installation

# Installing snapd
dnf -y install snapd

# enable classic snap support
ln -s /var/lib/snapd/snap /snap

sna="slack telegram-desktop gitkraken doctl"
# The main multi-loop for installing apps/libs through snapcraft store
for e in $sna; do
  snap install --classic $e;
done

# Install Google Chrome
curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
dnf -y install google-chrome-stable_current_x86_64.rpm

# Install Multimedia codecs
dnf -y install gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-free-extras ffmpeg

# Package gstreamer1-plugins-base-1.16.2-3.fc32.x86_64 is already installed.
# Package gstreamer1-plugins-good-1.16.2-2.fc32.x86_64 is already installed.
# Package gstreamer1-plugins-bad-free-1.16.2-3.fc32.x86_64 is already installed.
# Package ffmpeg-4.2.3-2.fc32.x86_64 is already installed.


# OnlyOffice Desktop Editors
dnf -y install https://download.onlyoffice.com/repo/centos/main/noarch/onlyoffice-repo.noarch.rpm

* Bootstrap Studio+
* SpiderOakONE+
* gandi+
* purevpn+
* Tresorit+

* asccinema+
* rhythmbox+
