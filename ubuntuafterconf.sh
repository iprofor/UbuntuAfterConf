#!/bin/bash

# enable some dns's

# Copyright Profor Ion, contact@iprofor.it
# 2017-08-26

# Inspirations sources

# Telemetry https://github.com/butteff/Ubuntu-Telemetry-Free-Privacy-Secure
# ClamAV
# RKHunter https://www.digitalocean.com/community/tutorials/how-to-use-rkhunter-to-guard-against-rootkits-on-an-ubuntu-vps


# Checking if the script is running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "Sorry, you need to run this as root"
  exit 1
fi


# Clear all previous bash variables
# exec bash;


# VARIABLES SECTION
# -----------------------------------

# mypath=$PWD;
hm="/home"
usr="crt"
ipinf=(ipinfo.io/ip);
bckp=(bckp);
dns_provider=(cisco);
hstnm=(latitude5289);
tmpth=/tmp/inst_session;
dn=/dev/null 2>&1
den1=(/dev/null);
rlog=(/root/installation.log);
nme="iprofor"
eml="git@iprofor.it"
apturl="http://10.0.2.2/ubuntu"
apturl2="http://10.0.2.2/ubuntu-partner"


# FUNCTIONS

# Updates/upgrades the system
up () {
  sctn_echo UPDATES;
  upvar="update upgrade dist-upgrade";
  for upup in $upvar; do
    echo -e "Executing \e[1m\e[34m$upup\e[0m";
    #apt-get -yqq -o=Dpkg::Use-Pty=0 $upup > $dn >> $rlog;
    apt-get -yqq $upup > /dev/null 2>&1 >> $rlog;
  done
  blnk_echo;
}


# Echoes that there is no X file
nofile_echo () {
  echo -e "\e[31mThere is no file named:\e[0m \e[1m\e[31m$@\e[0m";
}

# Echoes a standard message
std_echo () {
  echo -e "\e[32mPlease check it manually.\e[0m";
  echo -e "\e[1m\e[31mThis step stops here.\e[0m";
}

# Echoes that the internet connection was not switched off
netconon_echo () {
  echo -e "\e[31mThe internet connection was not switched \e[1m\e[31mOFF\e[0m \e[31mon previous step.\e[0m";
}

# Echoes that the internet connection was not switched off
netconof_echo () {
  echo -e "\e[31mThe internet connection was not switched \e[1m\e[31mON\e[0m \e[31mon previous step.\e[0m";
}

# Echoes that the given application is not running
notrun () {
  echo -e "\e[1m\e[31m$@\e[0m \e[31mis not running.\e[0m";
}

# Echoes that a specific application ($@) is being installed
inst_echo () {
  echo -e "Installing \e[1m\e[34m$@\e[0m";
}

# Echoes that a specific application ($@) is being downloaded
dwnl_echo () {
  echo -e "Downloading \e[1m\e[34m$@\e[0m";
}

# Echoes that a specific application ($@) is being backed up
cfg_echo () {
  echo -e "Configuring \e[1m\e[34m$@\e[0m";
}

# Echoes that a specific application ($@) is being purged with the reason
rm_echo () {
  echo -e "Removing \e[1m\e[34m$1\e[0m package because \e[1m\e[32m$2\e[0m";
}

# Echoes that a specific repository ($@) is being added
addrepo_echo () {
  echo -e "Importing \e[1m\e[34m$@\e[0m repository ...";
}

# Echoes that a specific repository key ($@) is being added
addrepokey_echo () {
  echo -e "Importing \e[1m\e[34m$@\e[0m repository key ...";
}

# Echoes activation of a specific application option ($@)
enbl_echo () {
  echo -e "Activating \e[1m\e[34m$@\e[0m ...";
}

# Echoes that a specific application ($@) is being updated
upd_echo () {
  echo -e "Updating \e[1m\e[34m$@\e[0m application ...";
}

# Echoes that updatng of a specific application ($@) failed
updfld_echo () {
  echo -e "Updating \e[1m\e[34m$@\e[0m application \e[1m\e[31mFAILED\e[0m.";
}

# Echoes there is no internet
nonet_echo () {
  echo -e "\e[1m\e[31mThere is no internet connection at the moment! Please try again later.\e[0m ...";
}

# Echoes the checked SHA256SUM do not corespond to the one had in local list
shaserr_echo () {
  echo -e "\e[1m\e[31mThe SHA256SUM of the downloaded package $@ has a different value. The archive was removed\e[0m";
}

# Echoes the link is invalid
nolnk_echo () {
  echo -e "The requested link \e[1m\e[31m$@\e[0m does not exist or it's name was changed meanwhile. Please try again later.";
}

# Backing up a given ($@) file/directory
bckup () {
  echo -e "Backing up: \e[1m\e[34m$@\e[0m ...";
  cp -r $@ $@_$(date +"%m-%d-%Y")."$bckp";
}

# Quiet installation
quietinst () {
  # DEBIAN_FRONTEND=noninteractive apt-get -yqq install $@ < null > /dev/null;
  DEBIAN_FRONTEND=noninteractive apt-get -yqqf install $@ > /dev/null >> $rlog;
#  DEBIAN_FRONTEND=noninteractive apt-get -yqqf install $@ < /dev/null > /dev/null >> $rlog;
}

chg_unat10 () {
  # The following options will have unattended-upgrades check for updates every day while cleaning out the local download archive each week.
  echo "
    APT::Periodic::Update-Package-Lists "1";
    APT::Periodic::Download-Upgradeable-Packages "1";
    APT::Periodic::AutocleanInterval "7";
    APT::Periodic::Unattended-Upgrade "1";" > $unat10;
}

blnk_echo () {
  echo ""
}

sctn_echo () {
  echo -e "\e[1m\e[33m$@\e[0m\n==================================================================================================";
}

scn_echo () {
  echo -e "\e[1m\e[34m$@\e[0m is scanning the OS ...";
}

# ------------------------------------------
# END VARIABLES SECTION



# BEGIN CONFIGURATION SECTION
# ----------------------------------

# Disabling the Ubuntu Network Manager
blnk_echo && echo -e "Network Connections are switched \e[1m\e[31mOFF\e[0m";
nmcli networking off && blnk_echo;

# Checking if there is NO internet connection
#if [[ ! $(curl -s ipinfo.io/ip) ]]; then
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ ! $? -eq 0 ]]; then

  # The main statement
  srclst=(/etc/apt/sources.list);

  # Cheking the existence of the $srclist configuration file
  if [ -f $srclst ]; then

    # Backing up the "/etc/apt/sources.list" file
    sctn_echo REPOSITORIES;
    bckup $srclst;

    # Enabling the Multiverse, Universe and Partner repositories as well as switching to the main (UK) repository servers.
    echo "Added the following repositories:" && echo -e "\e[1m\e[34mMultiverse\e[0m" && echo -e "\e[1m\e[34mUniverse\e[0m" && echo -e "\e[1m\e[34mPartner\e[0m";
    echo -e "Repository server: \e[1m\e[34marchive.ubuntu.com (UK)\e[0m" && blnk_echo;

    echo "
    # deb cdrom:[Ubuntu 16.04.6 LTS _Xenial Xerus_ - Release amd64 (20170801)]/ xenial main restricted

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://archive.ubuntu.com/ubuntu/ xenial main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ xenial main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ xenial universe
# deb-src http://archive.ubuntu.com/ubuntu/ xenial universe
deb http://archive.ubuntu.com/ubuntu/ xenial-updates universe
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://archive.ubuntu.com/ubuntu/ xenial multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial multiverse
deb http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu xenial partner
# deb-src http://archive.canonical.com/ubuntu xenial partner

deb http://security.ubuntu.com/ubuntu xenial-security main restricted
# deb-src http://security.ubuntu.com/ubuntu xenial-security main restricted
deb http://security.ubuntu.com/ubuntu xenial-security universe
# deb-src http://security.ubuntu.com/ubuntu xenial-security universe
deb http://security.ubuntu.com/ubuntu xenial-security multiverse
# deb-src http://security.ubuntu.com/ubuntu xenial-security multiverse
" > $srclst;

    # echo "
    # deb [arch=amd64] $apturl xenial main restricted
    # deb [arch=amd64] $apturl xenial-updates main restricted
    #
    # deb [arch=amd64] $apturl xenial universe
    # deb [arch=amd64] $apturl xenial-updates universe
    #
    # deb [arch=amd64] $apturl xenial multiverse
    # deb [arch=amd64] $apturl xenial-updates multiverse
    #
    # deb [arch=amd64] $apturl xenial-backports main restricted universe multiverse
    #
    # deb [arch=amd64] $apturl xenial-security main restricted
    # deb [arch=amd64] $apturl xenial-security universe
    # deb [arch=amd64] $apturl xenial-security multiverse
    #
    # deb [arch=amd64] $apturl2 xenial partner" > $srclst;

      # UFW
      ufwc=(/etc/ufw/ufw.conf);

      # Checking for the /etc/ufw/ufw.conf file
      if [ -f $ufwc ]; then

        # Backing up the file
        sctn_echo FIREWALL "(UFW)";
        bckup $ufwc;

        # Disabling IPV6 in UFW
        echo "IPV6=no" >> /etc/ufw/ufw.conf;
        echo -e "Disabling \e[1m\e[34mIPV6\e[0m in \e[1m\e[34mUFW\e[0m ...";

        # Applying UFW policies
        ufw default deny incoming > $dn >> $rlog && echo -e "Applied \e[1m\e[31mDENY INCOMING\e[0m policy" && ufw default deny outgoing > $dn >> $rlog && echo -e "Applied \e[1m\e[31mDENY OUTGOING\e[0m policy" && ufw enable > $dn >> $rlog && echo -e "UFW is \e[1m\e[32mENABLED\e[0m";
        # ufw status verbose; # for analyze only

        # TODO: Replace the following two for loops with a case like it is shown here + testing +testing https://stackoverflow.com/questions/43686878/pass-multiple-arrays-as-arguments-to-a-bash-script id:0 gh:2

        # Opening outgoing ports using UFW. Redirecting UFW output to /dev/null device
        # 80/tcp - for Web
        # 443/tcp - for secure Web (https) TCP&UDP
        # 53/tcp - for DNS TCP&UDP
        # 123/udp - for NTP
        # 43/tcp - for whois app to work properly
        # 22/tcp - for general SSH connections
        # 7539/tcp - for IJC VPS's SSH
        # 22170/tcp - for IJC Office's SSH
        # 2083/tcp - for cPanel SSL TCP
        # 2096/tcp - for cPanel Webmail SSL TCP
        # 51413 - for Transmission
        # 8000:8054/tcp - for audio feed of the Romanian Radio Broadcasting Society
        # 8078/tcp - for eTeatru audio feed of the Romanian Radio Broadcasting Society
        # 9128/tcp - for MagicFM and RockFM from Romania
        # 48231/tcp - IJC
        # 465/tcp - for SMTP SSL
        # 993/tcp - for IMAP SSL
        # 6697,7000,7070/tcp - Secure ports for irc.freenode.net (aka chat.freenode.net)
        # 6969/tcp - for Transmission (auxiliary necessary port)
        # 28893:28897/tcp - BL: SSH
        # 60309:60312/tcp - BL: SSL
        # 1194/udp - for openVPN
        # 3389/tcp - for RDP
        # 4440/tcp - for RunDeck's unsecured web interface
        # 4443/tcp - for RunDeck's secured web interface
        # 2222/tcp - for vagrant's local SSH
        # 587/tcp - for Hotmail


        ufw_out="80/tcp 443 53 123/udp 43/tcp 22/tcp 7539/tcp 22170/tcp 2083/tcp 2096/tcp 51413 8000:8054/tcp 8078/tcp 9128/tcp 48231/tcp 465/tcp 993/tcp 6697,7000,7070/tcp 6969/tcp 28893:28897/tcp 60309:60312/tcp 1194/udp 3389/tcp 4440/tcp 4443/tcp 2222/tcp 587/tcp";

        blnk_echo;
        echo "Opening the following outgoing ports:";
        for a in $ufw_out; do
          ufw allow out $a > $den1;
          echo -e "\e[1m\e[34m$a\e[0m";
        done

        # Opening incoming ports using UFW. Redirecting UFW output to /dev/null device
        # 465/tcp - for SMTP SSL
        # 993/tcp - for IMAP SSL
        # 1194/udp - for openVPN

        ufw_in="465/tcp 993/tcp 1194/udp";

        blnk_echo;
        echo "Opening the following incoming ports:";
        for a2 in $ufw_in; do
          ufw allow in $a2 > $den1;
          echo -e "\e[1m\e[34m$a2\e[0m";
        done

        ufw -f reload > $dn >> $rlog && echo -e "UFW is \e[1m\e[32mRELOADED\e[0m" && blnk_echo;

        # Checks if the firewall is running
        if ufw status verbose | grep -qw "active"; then


          # Enabling the Ubuntu Network Manager
          echo -e "Network Connections are switched \e[1m\e[32mON\e[0m";
          nmcli networking on && blnk_echo;

          # For some reason after enabling the firewall there is no way to make outgoing connections. The workaround is to disable the firewall, make an outgoing connection and the reenable it.
          ufw disable > $dn >> $rlog && wget -q --tries=10 --timeout=20 --spider http://google.com && ufw enable > $dn >> $rlog;
          # && ufw -f reload;
        	#/etc/init.d/ufw stop;
        	#/etc/init.d/ufw start;
        	#sleep 60;
          # Waiting several seconds for the changes to be applied
          sleep 20;

          # Checking if there is any internet connection
          #if [[ $(curl -s ipinfo.io/ip) ]]; then
          wget -q --tries=10 --timeout=20 --spider http://google.com;
          if [[ $? -eq 0 ]]; then

            # Updating repository lists
            sctn_echo UPDATE;
            echo "Updating repository lists ...";
            apt-get -yqq update > $dn >> $rlog && blnk_echo;

            # Installing dnscrypt-proxy
            sctn_echo INSTALLATION "#1";
            inst_echo dnscrypt-proxy;
            apt-get -yqq install dnscrypt-proxy > $den1;

            # Configuring DNSCrypt-Proxy
            dnscr_cfg=(/etc/default/dnscrypt-proxy);

            # Checking if DNSCrypt-Proxy is running
            if ! /etc/init.d/dnscrypt-proxy status -l | grep -w "Stopped DNSCrypt proxy." > $den1;
             then

              # Checking if the /etc/default/dnscrypt-proxy exists
              if [ -f $dnscr_cfg ]; then

                bckup $dnscr_cfg;
                cfg_echo dnscrypt-proxy;

                # Replacing the default DNS provider in the /etc/default/dnscrypt-proxy configuration file to the $dns_provider
                sed -i -e "/DNSCRYPT_PROXY_RESOLVER_NAME=/c\DNSCRYPT_PROXY_RESOLVER_NAME=$dns_provider" $dnscr_cfg;
                service dnscrypt-proxy restart;

                # Checking if DNSCrypt-Proxy is ON and running the chosen DNS Provider
                if ! /etc/init.d/dnscrypt-proxy status -l | grep -w "Stopped DNSCrypt proxy." > $den1 && /etc/init.d/dnscrypt-proxy status -l | grep  -w "resolver-name=$dns_provider" > $den1;

                # if ! /etc/init.d/dnscrypt-proxy status -l | grep -w "Stopped DNSCrypt proxy." && /etc/init.d/dnscrypt-proxy status -l | grep  -w "resolver-name=$dns_provider";
                then

                  blnk_echo;
                  echo -e "The configured DNSCrypt provider is \e[1m\e[32m$dns_provider\e[0m" && blnk_echo;

                  # Fixing DNSCrypt not starting up at boot
                  # dnser=(/etc/systemd/system/dnscrypt-proxy.service);
                  # dnsock=(/etc/systemd/system/dnscrypt-proxy.socket);
                  #
                  # bckup $dnser && mv $_*."$bckp" /root;
                  # bckup $dnsock && mv $_*."$bckp" /root;

                  # Pasting the new values
                  echo "[Unit]
Description=DNSCrypt proxy
Documentation=man:dnscrypt-proxy(8)
After=network.target iptables.service firewalld.service
Requires=dnscrypt-proxy.socket

[Service]
Type=notify
NonBlocking=true
User=_dnscrypt-proxy
Environment=DNSCRYPT_PROXY_RESOLVER_NAME=cisco \"DNSCRYPT_PROXY_OPTIONS=\"
EnvironmentFile=-/etc/default/dnscrypt-proxy
ExecStart=/usr/sbin/dnscrypt-proxy \\
    --resolver-name=\${DNSCRYPT_PROXY_RESOLVER_NAME} \\
    \$DNSCRYPT_PROXY_OPTIONS
Restart=always

[Install]
WantedBy=multi-user.target
Also=dnscrypt-proxy.socket" > /etc/systemd/system/dnscrypt-proxy.service;

                  # Pasting the new values
                  echo "[Unit]
Description=dnscrypt-proxy listening socket
Documentation=man:dnscrypt-proxy(8)
Wants=dnscrypt-proxy-resolvconf.service

[Socket]
ListenStream=127.0.2.1:53
ListenDatagram=127.0.2.1:53

[Install]
WantedBy=sockets.target" > /etc/systemd/system/dnscrypt-proxy.socket;

                  blnk_echo;

                  # Updating repository lists as well as updating/upgrading the system
                  up;

                  # Installing applications
                  sctn_echo INSTALLATION "#2";

                  # Adding external repositories

                  # "ppa:team-xbmc/ppa"
                  # "ppa:libreoffice/ppa"
                  apprepo=("ppa:wfg/0ad" "ppa:otto-kesselgulasch/gimp" "ppa:inkscape.dev/stable" "ppa:philip5/extra" "ppa:pmjdebruijn/darktable-release" "deb https://deb.opera.com/opera-stable/ stable non-free" "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" "deb https://download.sublimetext.com/ apt/stable/" "ppa:nextcloud-devs/client" "ppa:nitrokey-team/ppa" "ppa:serge-rider/dbeaver-ce" "ppa:videolan/stable-daily" "deb [arch=amd64] https://repo.skype.com/deb stable main" "ppa:andrewsomething/digitalocean" "deb https://packages.atlassian.com/debian/stride-apt-client $(lsb_release -c -s) main" "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main");
                  # "deb http://download.opensuse.org/repositories/home:/rawtherapee/xUbuntu_16.04/ /"

                  for b in "${apprepo[@]}"; do
                    addrepo_echo "${b[@]}";
                    add-apt-repository -y "${b[@]}" > /dev/null 2>&1 >> $rlog;
                  done

                  blnk_echo;


                  # Adding external repositories keys

                  apprepokey=("https://deb.opera.com/archive.key" "https://www.virtualbox.org/download/oracle_vbox_2016.asc" "https://www.virtualbox.org/download/oracle_vbox.asc" "https://download.sublimetext.com/sublimehq-pub.gpg" "https://packages.microsoft.com/keys/microsoft.asc"
                  "https://repo.skype.com/data/SKYPE-GPG-KEY"
                  "https://packages.atlassian.com/api/gpg/key/public"
                  "https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public");
                  # "http://download.opensuse.org/repositories/home:/rawtherapee/xUbuntu_16.04/Release.key"

                  for c in "${apprepokey[@]}"; do
                    addrepokey_echo "${c[@]}";
                    wget -qO- "${c[@]}" | sudo apt-key add - > $dn >> $rlog;
                  done

                  # @TODO This is a manual approach because right now I have no idea how to make the following line "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" inserted into sources.list file to throw no errors at the update stage.
                  echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list;

                  blnk_echo;
                  up;

                  sctn_echo INSTALLATION "#3";

                  # Libraries for the CLI/GUI Applications
                  # libc6:i386 - for ESET Antivirus for Linux
                  # (python2.7 - this package is already installed) python-gtk2 glade python-gtk-vnc python-glade2 python-configobj: for openxenmanager
                  # transcode - for K3B to rip DVDs
                  # python-gpgme - for Dropbox client
                  # firmware-b43-installer - wifi and sdhc card slot drivers for macmini
                  # gir1.2-webkit-3.0 - for digitalocean app indicator
                  # libncurses5-dev - for progress utility
                  # libnss-mdns:i386 - for crossover
                  # texlive-latex-base texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra - for pdflatex
                  applib="folder-color gedit-plugins gir1.2-webkit-3.0 glade gnome-color-manager hunspell-en-au hunspell-en-ca hunspell-en-gb hunspell-en-za hyphen-en-gb kde-l10n-engb libc6:i386 libgtk2-appindicator-perl libncurses5-dev libnss-mdns:i386 libpng16-16 libqt5core5a libqt5widgets5 libqt5x11extras5 libreoffice-help-en-gb libreoffice-l10n-en-gb libreoffice-l10n-en-za libsdl-ttf2.0-0 libsdl1.2debian mythes-en-au python-configobj python-glade2 python-gpgme python-gtk-vnc python-gtk2 rhythmbox-plugin-alternative-toolbar software-properties-common texlive-fonts-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended thunderbird-locale-en-gb transcode";

                  # CLI Applications
                  # dkms - for enabling USB devices inside guest OS for the VirtualBox's host OS
                  # do not need anymore: clamav clamav-daemon clamav-freshclam fail2ban
                  # for NitroKey opensc pcscd paperkey haveged gnupg2 gnupg-agent pinentry-curses libccid scdaemon libksba8 libpth20 gdebi-core
                  # for ruby: git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs yarn
                  appcli="adobe-flashplugin apache2 apt-listchanges apt-mirror arp-scan autoconf cmus curl debconf-utils default-jdk default-jre dkms dtrx duplicity exfat-fuse exfat-utils exiftool ffmpeg gdebi-core git git-core glances gnupg-agent gnupg2 gpgsm haveged htop iptraf libccid libcurl4-openssl-dev libffi-dev libksba8 libpth20 libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libxslt1-dev libyaml-dev lm-sensors lxd mc nodejs npm ntp ntpdate opensc opensc openssh-server p7zip p7zip-rar paperkey pcscd pinentry-curses powerline python-pip python-software-properties rar rcconf redshift rig scdaemon scdaemon screen shellcheck sqlite3 sysbench sysv-rc-conf tasksel terminator testdisk tig tmux tree unace unattended-upgrades wavemon whois xclip yarn zfsutils-linux zlib1g-dev";

                  # GUI Applications
                  # unity-tweaktool, shutter ?????
                  # do not need anymore: 0ad amarok brasero clamtk gnome-control-center gnome-online-accounts gpodder gwenview kate kodi krita ktorrent yakuake digikam5 geary indicator-cpufreq k3b gpick rawtherapee
                  appgui="aptoncd audacity bleachbit caffeine code compizconfig-settings-manager darktable dbeaver-ce deluge digitalocean-indicator easytag evolution filezilla gimp gimp-gmic gimp-plugin-registry gmic gnome-sushi glipper gnucash gparted gramps gresolver handbrake hexchat homebank indicator-multiload inkscape keepassx kmymoney mysql-workbench nautilus-actions nautilus-image-converter nextcloud-client nitrokey-app openttd pdfchain pdfshuffler pidgin redshift-gtk shutter soundconverter sound-juicer sublime-text skypeforlinux terminator unity-tweak-tool virtualbox-5.2 virt-viewer vlc workrave winff stride hipchat4 deluge-webui";

                  # The main multi-loop for installing apps/libs
                  for d in $applib $appcli $appgui; do
                    inst_echo $d;
                    apt-get -yqq install $d > /dev/null 2>&1 >> $rlog;
                  done

                  blnk_echo;
                  up;

                  # Separate installation subsection (1st)

                  sctn_echo INSTALLATION "#4";

                  # The installation of the following applications requires user interaction. It is installed separately in order to separate the installation lines and automation lines from the installation loop of the standard utilites that do not require user interaction at the instllation step.

                  # Here is a list of options that need to be autoanswered once during the installation process of the apps listed in the second variable ($debsel2)

                  debsel=(
                    "opera-stable opera-stable/add-deb-source select false"
                    # "macchanger macchanger/automatically_run select true"
                    "wireshark-common wireshark-common/install-setuid select true"
                    "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true"
                  );

                  # The applications that shows pop-ups during the their installation
                  debsel2=(
                    "opera-stable"
                    # "macchanger"
                    "wireshark"
                    "ubuntu-restricted-extras"
                  );

                  # The loop
                  for e in ${!debsel[*]}; do
                    inst_echo "${debsel2[$e]}";
                    echo "${debsel[$e]}" | debconf-set-selections && quietinst "${debsel2[$e]}";
                  done


                  blnk_echo;

                  # Installing RKHunter
                  # inst_echo RKHunter;
                  # debconf-set-selections <<< "postfix postfix/mailname string "$hstnm"" && debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Local Only'" && quietinst rkhunter;
                  #apt-get -yqq install rkhunter > $den1;

                  # blnk_echo;
                  up;

                  # END: Separate installation subsection (1st)

                  # Separate installation subsection (2nd)

                  sctn_echo INSTALLATION "#5";

                  # The loop
                  tmpth=/tmp/inst_session;
                  mkdir -p $tmpth && cd $tmpth;

                  # The list of direct links to the downloaded apps
                  app=(
                    # "https://bitbucket.org/crtcji/ubuntunecessaryapps/raw/895b7a005785d11f63843787799b6a8dadfe2894/skype.deb"
                    "https://bitbucket.org/crtcji/ubuntunecessaryapps/raw/895b7a005785d11f63843787799b6a8dadfe2894/atom.deb"
                    # "https://bitbucket.org/crtcji/ubuntunecessaryapps/raw/895b7a005785d11f63843787799b6a8dadfe2894/pac.deb"
                    # "https://bitbucket.org/crtcji/ubuntunecessaryapps/raw/895b7a005785d11f63843787799b6a8dadfe2894/dbeaver.deb"
                    );

                  # The list of 256 shasums of the eralier downloaded apps
                  app2=(
                    # "1f31c0e9379f680f2ae2b4db3789e936627459fe0677306895a7fa096c7db2c5"
                    "870a763c3033db8b812f3367e2de7bb383ba2d791b6ab9af70e31e7ad33ddbac"
                    # "82e73c8631fe055a79dc4352956ed22df05cbae1886ceaeb22b2bf562b0eb9ca"
                    # "6abfd028162f3cb0044aebf191cdf2887414c83d5fd008565024c44fee074c4e"
                    );

                  # The list of names of the downloaded apps
                  app3=(
                    # "skype.deb"
                    "atom.deb"
                    # "pac.deb"
                    # "dbeaver.deb"
                    );

                  # Checking if there is any internet connection by getting ones public IP
                  if [[ $(curl --silent $ipinf) ]]; then

                    for f in ${!app[*]}; do

                      # Checking if the required link is valid
                      if curl -L --output /dev/null --silent --fail -r 0-0 "${app[$f]}"; then

                        # Getting the actual installation package
                        curl -L --silent "${app[$f]}" > "${app3[$f]}";

                        # Verifying the SHA256SUM of the package
                        if [[ $(shasum -a 256 "${app3[$f]}" | grep "${app2[$f]}") ]]; then

                          # Installing the application with necesary dependencies (-yf parameter)
                          inst_echo "${app3[$f]}";
                          quietinst $tmpth/"${app3[$f]}";

                        else
                          rm -rf $tmpth/"${app3[$f]}";
                          shaserr_echo "${app3[$f]}";
                        fi;

                      else
                          nolnk_echo "${app[$f]}";
                      fi;

                    done

                    blnk_echo;

                  else
                      nonet_echo;
                      std_echo;
                  fi

                  up;

                  # END: Separate installation subsection (2nd)



                  # Separate installation subsection (3rd)

                  # sctn_echo INSTALLATION "#6";
                  #
                  # # The loop
                  # applctn=/usr/bin;
                  # #tmpth=/tmp/inst_session;
                  # #mkdir -p $tmpth && cd $tmpth;
                  #
                  # # The list of direct links to the downloaded apps
                  # app=(
                  #   "https://bitbucket.org/crtcji/ubuntunecessaryapps/raw/4fb37e36006838b913cae644ef497d8787ca67b1/vcrypt.tar"
                  #   # "https://download.jetbrains.com/python/pycharm-edu-4.0.tar.gz"
                  #   );
                  #
                  # # The list of 256 shasums of the eralier downloaded apps
                  # app2=(
                  #   "b6a1c8000e9d1bb707e7276e24b8777bea435ec28aa549cfb552b94194a48088"
                  #   # "ff057e9ad76e58f7441698aec3d0200d7808a9a113e0db7030f432d5289ee30b"
                  #   );
                  #
                  # # The list of names of the downloaded ppps
                  # app3=(
                  #   "vcrypt.tar"
                  #   # "pycharm.tar.gz"
                  #   );
                  #
                  # # Checking if there is any internet connection by getting ones public IP
                  # if [[ $(curl --silent $ipinf) ]]; thens
                  #
                  #   for g in ${!app[*]}; do
                  #
                  #     # Checking if the required link is valid
                  #     if curl -L --output /dev/null --silent --fail -r 0-0 "${app[$g]}"; then
                  #
                  #       # Getting the actual installation package
                  #        dwnl_echo "${app3[$g]}";
                  #        curl -L --silent "${app[$g]}" > "${app3[$g]}";
                  #
                  #       # Verifying the SHA256SUM of the package
                  #       if [[ $(shasum -a 256 "${app3[$g]}" | grep "${app2[$g]}") ]]; then
                  #
                  #         # Unarchiving the application into $applctn
                  #         inst_echo "${app3[$g]}";
                  #         tar -xf $tmpth/"${app3[$g]}" -C $applctn;
                  #
                  #       else
                  #         rm -rf $tmpth/"${app3[$g]}";
                  #         shaserr_echo "${app3[$g]}";
                  #       fi;
                  #
                  #     else
                  #         nolnk_echo "${app[$g]}";
                  #     fi;
                  #
                  #   done
                  #
                  # else
                  #     nonet_echo;
                  #     std_echo;
                  # fi
                  #
                  # # END: Separate installation subsection (3nd)


                  # Separate installation subsection (4th)

                  # Calibre
                  # inst_echo Calibre;
                  # sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" > $dn >> $rlog;
                  # curl -LO https://download.calibre-ebook.com/linux-installer.py
                  # python linux-installer.py > /dev/null

                  ca_lnk=(https://download.calibre-ebook.com/linux-installer.py);
                  ca=(calibre.py);

                  # Checking if there is any internet connection by getting ones public IP
                  if [[ $(curl --silent $ipinf) ]]; then

                    # Checking if the required link is valid
                    if curl -L --output /dev/null --silent --fail -r 0-0 $ca_lnk; then

                      # Getting the actual installation package
                      dwnl_echo $ca;
                      curl -L --silent $ca_lnk > $ca;

                          inst_echo $ca;
                          # Installing
                          python $ca > /dev/null >> $rlog;
                    else
                        nolnk_echo $ca_lnk;
                    fi;

                  else
                      nonet_echo;
                      std_echo;
                  fi


                  # # Netbeans
                  # nb_lnk=(http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh);
                  # nb_shsm=('0442d4eaae5334f91070438512b2e8abf98fc84f07a9352afbc2c4ad437d306c');
                  # nb=(netbeans-8.2-linux.sh);
                  #
                  # # Checking if there is any internet connection by getting ones public IP
                  # if [[ $(curl --silent $ipinf) ]]; then
                  #
                  #   # Checking if the required link is valid
                  #   if curl -L --output /dev/null --silent --fail -r 0-0 $nb_lnk; then
                  #
                  #     # Getting the actual installation package
                  #     dwnl_echo $nb;
                  #     curl -L --silent $nb_lnk > $nb;
                  #
                  #     # Verifying the SHA256SUM of the archive
                  #     if [[ $(shasum -a 256 $nb | grep $nb_shsm) ]]; then
                  #
                  #         # Installing the package
                  #         inst_echo $nb;
                  #         # Setting executable rights
                  #         chmod +x $nb;
                  #         # Installing
                  #         su -c "./$nb --silent" -s /bin/sh $usr
                  #
                  #     else
                  #         rm -rf $tmpth/$nb;
                  #         shaserr_echo $nb;
                  #     fi;
                  #
                  #   else
                  #       nolnk_echo $nb;
                  #   fi;
                  #
                  # else
                  #     nonet_echo;
                  #     std_echo;
                  # fi

                  up;
                  blnk_echo;

                  # Asbru Connection Manager
                  acm=(asbru-cm);
                  inst_echo $acm
            		  wget -qO- https://packagecloud.io/install/repositories/$acm/$acm/script.deb.sh | sudo bash > /dev/null 2>&1 >> $rlog;
                  apt-get -yqq install $acm > /dev/null 2>&1 >> $rlog;

                  up;

                  # Separate installation subsection (3rd)

                  sctn_echo INSTALLATION "#7";

                  applnk=(
                    # "https://www.zoho.com/cliq/downloads/nativeapps/Cliq_1.1.0_amd64.deb"
                    "https://downloads.vivaldi.com/stable/vivaldi-stable_1.14.1077.55-1_amd64.deb"
                    "https://update.gitter.im/linux64/gitter_3.1.0_amd64.deb"
                    # "https://downloads.slack-edge.com/linux_releases/slack-desktop-3.1.1-amd64.deb"
                  );

                  # The applications that shows pop-ups during the their installation
                  appnm=(
                    # "cliq.deb"
                    "vivaldi.deb"
                    "gitter.deb"
                    # "slack.deb"
                  );

                  # The loop
                  for g2 in ${!applnk[*]}; do
                    # dwnl_echo "${appnm[$g2]}";
                    # echo "${applnk[$g2]}"
                    curl -L ${applnk[*]} > ${appnm[$g2]}; #> /dev/null 2>&1 #>> $rlog;
                    apt-get -yqqf install $PWD/${appnm[$g2]}; # > /dev/null 2>&1; #>> $rlog;
                  done

                  up;

                  # # Zoho Cliq
                  # dwnl_echo Cliq
            		  # curl -LO https://www.zoho.com/cliq/downloads/nativeapps/Cliq_1.1.0_amd64.deb > /dev/null 2>&1 >> $rlog;
                  # inst_echo Cliq
                  # dpkg -i Cliq_1.1.0_amd64.deb > /dev/null 2>&1 >> $rlog;


                  # # Vivaldi Browser
                  # vivaldi=(vivaldi-stable_1.14.1077.55-1_amd64.deb);
                  # curl -LO https://downloads.vivaldi.com/stable/$vivaldi > /dev/null 2>&1 >> $rlog;
                  # dpkg -i $vivaldi > /dev/null 2>&1 >> $rlog;

                  # ### gitter.im
                  # curl -LO https://update.gitter.im/linux64/gitter_3.1.0_amd64.deb
                  # dpkg -i gitter_3.1.0_amd64.deb


                  # ### slack
                  # curl -LO https://downloads.slack-edge.com/linux_releases/slack-desktop-3.1.1-amd64.deb
                  # dpkg -i slack-desktop-3.1.1-amd64.deb

                  ### mattermost client
                  curl -LO https://releases.mattermost.com/desktop/4.0.1/mattermost-desktop-4.0.1-linux-amd64.deb
                  dpkg -i mattermost-desktop-4.0.1-linux-amd64.deb


                  ### rocketchat
                  curl -LO https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/2.10.5/rocketchat_2.10.5_amd64.deb

                  ### telegram
                  curl -LO https://telegram.org/dl/desktop/linux


                  # snap installations
                  inst_echo doctl lxd canonical-livepatch
                  snap install doctl lxd canonical-livepatch > $dn >> $rlog;

                  # Slack, Micro Editor
                  inst_echo Slack, Micro
                  snap install slack micro --edge --classic > /dev/null 2>&1 >> $rlog;

                  up;

                  # Updating Python PIP
                  echo -e "Updating \e[1m\e[34mpip\e[0m";
                  pip install --upgrade pip > $dn >> $rlog;

                  # Installing Speedest-CLI
                  inst_echo Speedtest;
                  pip install speedtest-cli --upgrade > $dn >> $rlog;#

                  # Installing AWS-CLI
                  inst_echo AWS-CLI;
                  pip install awscli --upgrade > $dn >> $rlog;

                  # Run as simple user
                  # - `export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"`
                  #
                  # - `echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list`
                  #
                  # - `curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -`
                  #
                  # And as root
                  # - `apt-get -y update && apt-get -y install google-cloud-sdk`
                  #
                  # **Optional**
                  # - `apt-get -y install google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-java google-cloud-sdk-app-engine-go google-cloud-sdk-datalab google-cloud-sdk-datastore-emulator google-cloud-sdk-pubsub-emulator google-cloud-sdk-cbt google-cloud-sdk-bigtable-emulator kubectl`

                  blnk_echo;
                  up;

                  # END: Separate installation subsection (4th)


                  # Installing dependency for "atom-beautify" plugin
                  inst_echo beautysh;
                  pip install beautysh > $dn >> $rlog;


                  # Starting a $usr subshell

                  su $usr bash -c '

                  # Atom addons installation section
                  # Default location $hm/$usr/.atom/packages

                  apms="aligner-php ask-stack atom-beautify atom-csv-markdown atom-html-preview atom-material-syntax atom-material-ui atom-mysql-snippets atom-reverser atom-wordpress auto-update-plus autocomplete-paths autocomplete-php autocomplete-wordpress-hooks build busy-signal chronometer code-peek color-picker duplicate-line-or-selection emmet emmet file-icons fold-navigator fonts git-blame git-control git-time-machine highlight-line highlight-selected imdone-atom imdone-atom-github intentions language-docker language-markdown language-routeros-script language-svg linter linter-csslint linter-htmlhint linter-js-yaml linter-jshint linter-php linter-phpcs linter-phpmd linter-scss-lint linter-shellcheck linter-tidy linter-ui-default livereload markdown-pdf markdown-preview-plus markdown-writer merge-conflicts minimap pandoc-convert pigments platformio-ide-terminal preview project-manager script sort-lines sunset svg-preview symbols-tree-view sync-settings tablr theme-switch todo-show tomato-timer tool-bar tool-bar-main tool-bar-markdown-writer tree-view-git-status typewriter updater-notify wakatime wordcount wordpress wordpress-api wordpress-dictionary wordpress-suite wp-dev zen";

                  echo "Installing Atom plugins:";

                  mkdir -p '$hm'/'$usr'/.atom/packages;

                  for m in $apms; do
                    echo -e "\e[1m\e[34m$m\e[0m";
                    apm install $m > /home/crt/installation.log;
                  done


                  # JetBrains ToolBox
                  cd '$hm'/'$usr'/Downloads;
                  curl -LO https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.6.2914.tar.gz > /dev/null 2>&1 >> $rlog;
                  tar -xf jetbrains-toolbox-1.6.2914.tar.gz > /dev/null 2>&1 >> $rlog;

                  # Zoho Docs universal link
                  curl -LO https://www.zoho.com/docs/36925/ZohoDocs_x64.tar.gz
                  tar -xf ZohoDocs_x64.tar.gz

                  # Tresorit
                  curl -LO https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run
                  chmod +x tresorit_installer.run
                  # && ./tresorit_installer.run
                  # answer "n" twice

                  exit'

                  blnk_echo;

                  # END: Atom addons installation section

                  # The End of the $usr subshell

                  # END: Installing CLI utilities


                  # Telemetry
                  # Removing packages that send statisrics and usage data to Canonical and third-parties

                  # sctn_echo TELEMETRY;
                  #
                  # # Guest session disable
                  # sudo sh -c 'printf "[SeatDefaults]\nallow-guest=false\ngreeter-show-remote-login=false\n" > /etc/lightdm/lightdm.conf.d/50-no-guest.conf'
                  #
                  # telepack=(
                  # "unity-lens-shopping"
                  # "unity-webapps-common"
                  # # "apturl"
                  # # "remote-login-service"
                  # # "lightdm-remote-session-freerdp"
                  # # "lightdm-remote-session-uccsconfigure"
                  # # "zeitgeist"
                  # # "zeitgeist-datahub"
                  # # "zeitgeist-core"
                  # # "zeitgeist-extension-fts"
                  # "cups"
                  # "cups-server-common"
                  # # "remmina"
                  # # "remmina-common"
                  # # "remmina-plugin-rdp"
                  # # "remmina-plugin-vnc"
                  # "unity8*"
                  # "gdbserver"
                  # # "gvfs-fuse"
                  # # "evolution-data-server"
                  # # "evolution-data-server-online-accounts"
                  # # "snapd"
                  # "libhttp-daemon-perl"
                  # "vino"
                  # # "unity-scope-video-remote"
                  # )
                  #
                  # # Comments to each purged telepack
                  # telepack2=(
                  # "Unity Amazon"
                  # "Unity web apps"
                  # # "gives possibilities to start installation by clicking on url, can be executed with js, which is not secure"
                  # # "remote login for LightDm"
                  # # "remote login rdp for LightDm"
                  # # "remote login uccsconfigure for LightDm"
                  # # "Zeitgeist Basic Telemetry"
                  # # "Zeitgeist Basic Telemetry"
                  # # "Zeitgeist Basic Telemetry"
                  # # "Zeitgeist Basic Telemetry"
                  # "if you don't use printers"
                  # "if you don't use printers"
                  # # "has libraries for remote connection, which can be unsecure"
                  # # "has libraries for remote connection, which can be unsecure"
                  # # "has libraries for remote connection, which can be unsecure"
                  # # "has libraries for remote connection, which can be unsecure"
                  # "just remove it, because of potential telemetry from unity8, which is in beta state and exists only for preview, for now you can use 7 version. potential problem"
                  # "remote tool for gnome debug"
                  # # "virtual file system.potential problem"
                  # # "I just don't like server word here. Potentional connection possibility? potential problem"
                  # # "potential problem"
                  # # "telemetric package manager from canonical"
                  # "http server for perl"
                  # "vnc server (remote desktop share tool)"
                  # # "potential problem"
                  # )
                  #
                  # # The loop
                  # for h in ${!telepack[*]}; do
                  #   rm_echo "${telepack[$h]}" "${telepack2[$h]}" ;
                  #   apt-get -yqq purge "${telepack[$h]}" > $den1;
                  # done
                  #
                  # blnk_echo;
                  #
                  #
                  # # END: Telemetry section


                  # # ClamAV section: configuration and the first scan
                  #
                  # clmcnf=(/etc/clamav/freshclam.conf);
                  # rprtfldr=(/home/$usr/ClamAV-Reports);
                  #
                  # sctn_echo ANTIVIRUS "(Clam-AV)";
                  # bckup $clmcnf;
                  # mkdir -p $rprtfldr;
                  #
                  # # Enabling "SafeBrowsing true" mode
                  # enbl_echo SafeBrowsing;
                  # echo "SafeBrowsing true" >> $clmcnf;
                  #
                  # # Restarting CLAMAV Daemons
                  # /etc/init.d/clamav-daemon restart && /etc/init.d/clamav-freshclam restart
                  # # clamdscan -V s
                  #
                  # # Scanning the whole system and palcing all the infected files list on a particular file
                  # # echo "ClamAV is scanning the OS ...";
                  # scn_echo ClamAv
                  # # This one throws any kind of warnings and errors: clamscan -r / | grep FOUND >> $rprtfldr/clamscan_first_scan.txt > $dn >> $rlog;
                  # clamscan --recursive --no-summary --infected / 2>/dev/null | grep FOUND >> $rprtfldr/clamscan_first_scan.txt;
                  # # Crontab: The daily scan
                  #
                  # # The below cronjob will run a virus database definition update (so that the scan always has the most recent definitions) and afterwards run a full scan which will only report when there are infected files on the system. It also does not remove the infected files automatically, you have to do this manually. This way you make sure that it does not delete /bin/bash by accident.
                  # #
                  # # The 2>/dev/null options keeps the /proc and such access denied errors out of the report. The infected files however are still found and reported.
                  # #
                  # # Also make sure that your cron is configured so that it mails you the output of the cronjobs. The manual page will help you with that.
                  #
                  # # One way: if the computer is off in the time frame when it is supposed to be scanned by the daemon, it will NOT be scanned next time the computer is on.
                  #                   #crontab -l | { cat; echo "
                  # # ## ClamAV Daily scan
                  # # 30 01 * * * /usr/bin/freshclam --quiet; /usr/bin/clamscan --recursive --no-summary --infected / 2>/dev/null >> $rprtfldr/clamscan_daily.txt"; } | crontab -
                  #
                  # # This way, Anacron ensures that if the computer is off during the time interval when it is supposed to be scanned by the daemon, it will be scanned next time it is turned on, no matter today or another day.
                  # echo -e "Creating a \e[1m\e[34mcronjob\e[0m for the ClamAV ...";
                  # echo -e '#!/bin/bash\n\n/usr/bin/freshclam --quiet;\n/usr/bin/clamscan --recursive --exclude-dir=/media/ --no-summary --infected / 2>/dev/null >> '$rprtfldr'/clamscan_daily_$(date +"%m-%d-%Y").txt;' >> /etc/cron.daily/clamscan.sh && chmod 755 /etc/cron.daily/clamscan.sh;
                  #
                  # blnk_echo;
                  #
                  # # END: ClamAV section: configuration and the first scan


                  # NOTE - need to retest
                  # # RKHunter configuration section
                  # sctn_echo ANTI-MALWARE "(RKHunter)"
                  # # The first thing we should do is ensure that our rkhunter version is up-to-date.
                  # rkhunter --versioncheck > $dn >> $rlog;
                  #
                  # # Verifying if the previous command run successfully (exit status 0) then it goes to the next step
                  # RESULT=$?
                  # if [ $RESULT -eq 0 ]; then
                  #   upd_echo rkhunter;
                  #   # Updating our data files.
                  #
                  #   # // FIXME: The following two commands are a temporary workaround because for the first time of running it gives eq=1, so there is a need to tun it for the second time in order to get eq=0 so that the rest of the statements are executed. id:1 gh:3
                  #   rkhunter --update > $dn >> $rlog;
                  #   rkhunter --update > $dn >> $rlog;
                  #
                  #   RESULT2=$?
                  #   if [ $RESULT2 -eq 0 ]; then
                  #     upd_echo rkhunter signatures;
                  #     # With our database files refreshed, we can set our baseline file properties so that rkhunter can alert us if any of the essential configuration files it tracks are altered. We need to tell rkhunter to check the current values and store them as known-good values:
                  #     rkhunter --propupd > $dn >> $rlog;
                  #
                  #     RESULT3=$?
                  #     if [ $RESULT3 -eq 0 ]; then
                  #       scn_echo RKHunter
                  #       # Finally, we are ready to perform our initial run. This will produce some warnings. This is expected behavior, because rkhunter is configured to be generic and Ubuntu diverges from the expected defaults in some places. We will tell rkhunter about these afterwards:
                  #       # rkhunter -c --enable all --disable none
                  #
                  #       # Note: This will be executed only if the previous one was executed
                  #       # Another alternative to checking the log is to have rkhunter print out only warnings to the screen, instead of all checks:
                  #       rkhunter -c --enable all --disable none --rwo > $dn >> $rlog;
                  #
                  #     else
                  #       echo "\e[1m\e[34mRKHunter\e[0m is scanning the OS \e[1m\e[31mFAILED\e[0m.";
                  #       std_echo;
                  #     fi
                  #
                  #
                  #   else
                  #     updfld_echo rkhunter signatures;
                  #     std_echo;
                  #   fi
                  #
                  # else
                  #   updfld_echo rkhunter;
                  #   std_echo;
                  # fi
                  #
                  #
                  # # for viewing the logs
                  # # cat /var/log/rkhunter.log | grep -w "Warning:"
                  #
                  # # Crontab (Anacron): The daily scan
                  # # The previous 3 if statements are useless, because the line bellow do all the same
                  # # The --cronjob option tells rkhunter to not output in a colored format and to not require interactive key presses. The update option ensures that our definitions are up-to-date. The quiet option suppresses all output.
                  # echo -e '#!/bin/bash\n\n/usr/bin/rkhunter --cronjob --update --quiet;' >> /etc/cron.daily/rkhunter_scan.sh && chmod 755 /etc/cron.daily/rkhunter_scan.sh;
                  #
                  # blnk_echo;
                  #
                  # # END: RKHunter configuration section


                  # Unattended-Upgrades configuration section
                  sctn_echo AUTOUPDATES "(Unattended-Upgrades)";

                  unat20=(/etc/apt/apt.conf.d/20auto-upgrades);
                  unat50=(/etc/apt/apt.conf.d/50unattended-upgrades);
                  unat10=(/etc/apt/apt.conf.d/10periodic);

                  # Cheking the existence of the $unat20, $unat50, $unat10 configuration files
                  if [[ -f $unat20 ]] && [[ -f $unat50 ]] && [[ -f $unat10 ]]; then

                    for i in $unat20 $unat50 $unat10; do
                      bckup $i && mv $i*."$bckp" /root;
                    done


                    # Inserting the right values into it
                    echo "
                      APT::Periodic::Update-Package-Lists "1";
                      APT::Periodic::Unattended-Upgrade "1";
                      APT::Periodic::Verbose "2";" > $unat20;


                        # Checking if line for security updates is uncommented, by default it is
                        if [[ $(cat $unat50 | grep -wx '[[:space:]]"${distro_id}:${distro_codename}-security";') ]]; then

                          chg_unat10;
                        else
                          echo "
                  // Automatically upgrade packages from these (origin:archive) pairs
                  Unattended-Upgrade::Allowed-Origins {
                  	"${distro_id}:${distro_codename}";
                  	"${distro_id}:${distro_codename}-security";
                  	// Extended Security Maintenance; doesn't necessarily exist for
                  	// every release and this system may not have it installed, but if
                  	// available, the policy for updates is such that unattended-upgrades
                  	// should also install from here by default.
                  	"${distro_id}ESM:${distro_codename}";
                  //	"${distro_id}:${distro_codename}-updates";
                  //	"${distro_id}:${distro_codename}-proposed";
                  //	"${distro_id}:${distro_codename}-backports";
                  };

                  // List of packages to not update (regexp are supported)
                  Unattended-Upgrade::Package-Blacklist {
                  //	"vim";
                  //	"libc6";
                  //	"libc6-dev";
                  //	"libc6-i686";
                  };

                  // This option allows you to control if on a unclean dpkg exit
                  // unattended-upgrades will automatically run
                  //   dpkg --force-confold --configure -a
                  // The default is true, to ensure updates keep getting installed
                  //Unattended-Upgrade::AutoFixInterruptedDpkg "false";

                  // Split the upgrade into the smallest possible chunks so that
                  // they can be interrupted with SIGUSR1. This makes the upgrade
                  // a bit slower but it has the benefit that shutdown while a upgrade
                  // is running is possible (with a small delay)
                  //Unattended-Upgrade::MinimalSteps "true";

                  // Install all unattended-upgrades when the machine is shuting down
                  // instead of doing it in the background while the machine is running
                  // This will (obviously) make shutdown slower
                  //Unattended-Upgrade::InstallOnShutdown "true";

                  // Send email to this address for problems or packages upgrades
                  // If empty or unset then no email is sent, make sure that you
                  // have a working mail setup on your system. A package that provides
                  // 'mailx' must be installed. E.g. "user@example.com"
                  //Unattended-Upgrade::Mail "root";

                  // Set this value to "true" to get emails only on errors. Default
                  // is to always send a mail if Unattended-Upgrade::Mail is set
                  //Unattended-Upgrade::MailOnlyOnError "true";

                  // Do automatic removal of new unused dependencies after the upgrade
                  // (equivalent to apt-get autoremove)
                  //Unattended-Upgrade::Remove-Unused-Dependencies "false";

                  // Automatically reboot *WITHOUT CONFIRMATION*
                  //  if the file /var/run/reboot-required is found after the upgrade
                  //Unattended-Upgrade::Automatic-Reboot "false";

                  // If automatic reboot is enabled and needed, reboot at the specific
                  // time instead of immediately
                  //  Default: "now"
                  //Unattended-Upgrade::Automatic-Reboot-Time "02:00";

                  // Use apt bandwidth limit feature, this example limits the download
                  // speed to 70kb/sec
                  //Acquire::http::Dl-Limit "70";" > $unat50;

                          chg_unat10;
                        fi

                        # The results of unattended-upgrades will be logged to /var/log/unattended-upgrades.
                        # For more tweaks nano /etc/apt/apt.conf.d/50unattended-upgrades

                  blnk_echo;

                  else
                    nofile_echo $unat20 or $unat50 or $unat10;
                    std_echo;
                  fi

                  # END: Unattended-Upgrades configuration section


                  # Startup Applications (GUI)
                  sctn_echo STARTUP APPLICATIONS

                  # Running the following commands as $usr so that the created files are going to have it's owner's rights
                  su $usr bash -c '

                  # The list of the shortcuts names
                  appshrt=(
                    "firefox.desktop"
                    "atom.desktop"
                    "redshift-gtk.desktop"
                    "rhythmbox.desktop"
                    "virtualbox.desktop"
                    "zohodocs.desktop"
                    "skype.desktop"
                    "nextcloud.desktop"
                    "megasync.desktop"
                    "dropbox.desktop"
                    "caffeine-indicator.desktop"
                    "tresorit.desktop"
                    "zoho-cliq.desktop"
                    "hipchat.desktop"
                    "keepassx.desktop"
                    "thunderbird.desktop"
                    "asbru-cm_start.desktop"
                    "teamdrive.desktop"
                    "evolution.desktop"
                    "hexchat.desktop"
                    "nitrokey.desktop"
                    "deluge-gtk.desktop"
                    "remmina-applet.desktop"
                    "digitalocean-indicator-autostart.desktop"
                    "gitter.desktop"
                    "keepassxc.desktop"
                    "mattermost-desktop.desktop"
                    "stride.desktop"
                  );

                  # The list of the shortcuts names content
                  appshrt2=(
                    "[Desktop Entry]
                    Type=Application
                    Exec=firefox
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Mozilla Firefox
                    Name=Mozilla Firefox
                    Comment[en_US]=Autostarting Firefox with the OS
                    Comment=Autostarting Firefox with the OS"

                    "[Desktop Entry]
                    Type=Application
                    Exec=atom
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Atom Editor
                    Name=Atom Editor
                    Comment[en_US]=Autostarting at OS boot
                    Comment=Autostarting at OS boot
                    X-GNOME-Autostart-Delay=10"

                    "[Desktop Entry]
                    StartupNotify=true
                    Categories=Utility;
                    GenericName=Color temperature adjustment
                    X-GNOME-Autostart-enabled=true
                    Version=1.0
                    Terminal=false
                    Comment=Color temperature adjustment tool
                    Name=Redshift
                    Exec=redshift-gtk
                    Icon=redshift
                    Hidden=false
                    Type=Application"

                    "[Desktop Entry]
                    Type=Application
                    Exec=rhythmbox-client --play-uri=http://astreaming.vibefm.ro:8000/vibefm_aacp48k
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Rhythmbox
                    Name=Rhythmbox
                    Comment[en_US]=Rhythmbox
                    Comment=Rhythmbox"

                    "[Desktop Entry]
                    Type=Application
                    Exec=virtualbox
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=VirtualBox
                    Name=VirtualBox
                    Comment[en_US]=VirtualBox
                    Comment=VirtualBox
                    X-GNOME-Autostart-Delay=120"

                    "[Desktop Entry]
                    Name=Zoho Docs
                    Comment=Sync documents to Zoho Docs
                    Exec=/home/crt/.zohodocs/bin/zohodocs -sstart
                    Terminal=false
                    Type=Application
                    Icon=/home/crt/.zohodocs/bin/images//r1.png
                    Categories=Network;FileTransfer;
                    MimeType=application/x-zwriter-link;application/x-zsheet-link;application/x-zshow-link;
                    StartupNotify=false
                    X-GNOME-Autostart-Delay=15"

                    "[Desktop Entry]
                    Type=Application
                    Exec=skypeforlinux
                    Hidden=true
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Skype for linux
                    Name=Skype for linux
                    Comment[en_US]=Auto launching Skype for linux
                    Comment=Auto launching Skype for linux
                    X-GNOME-Autostart-Delay=17"

                    "[Desktop Entry]
                    Name=Nextcloud
                    GenericName=File Synchronizer
                    Exec=/usr/bin/nextcloud
                    Terminal=false
                    Icon=nextcloud
                    Categories=Network
                    Type=Application
                    StartupNotify=false
                    X-GNOME-Autostart-enabled=true
                    X-GNOME-Autostart-Delay=30"

                    "[Desktop Entry]
                    Type=Application
                    Version=1.0
                    GenericName=File Synchronizer
                    Name=MEGASync
                    Comment=Easy automated syncing between your computers and your MEGA cloud drive.
                    TryExec=megasync
                    Exec=megasync
                    Icon=mega
                    Terminal=false
                    Categories=Network;System;
                    StartupNotify=false
                    X-GNOME-Autostart-Delay=45"

                    "[Desktop Entry]
                    Name=Dropbox
                    GenericName=File Synchronizer
                    Comment=Sync your files across computers and to the web
                    Exec=dropbox start -i
                    Terminal=false
                    Type=Application
                    Icon=dropbox
                    Categories=Network;FileTransfer;
                    StartupNotify=false
                    X-GNOME-Autostart-Delay=40"

                    "[Desktop Entry]
                    Type=Application
                    Exec=caffeine-indicator
                    Hidden=true
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Caffeine Indicator
                    Name=Caffeine Indicator
                    Comment[en_US]=Auto launching Caffeine Indicator
                    Comment=Auto launching Caffeine Indicator"

                    "[Desktop Entry]
                    Type=Application
                    Exec=Exec='$hm'/'$usr'/.local/share/tresorit/tresorit
                    Hidden=true
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Tresorit
                    Name=Tresorit
                    Comment[en_US]=Auto launching Tresorit
                    Comment=Auto launching Tresorit
                    X-GNOME-Autostart-Delay=42"

                    "[Desktop Entry]
                    Type=Application
                    Exec=cliq
                    Hidden=true
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Zoho Cliq
                    Name=Zoho Cliq
                    Comment[en_US]=Auto launching Zoho Cliq
                    Comment=Auto launching Zoho Cliq
                    X-GNOME-Autostart-Delay=38"

                    "[Desktop Entry]
                    Type=Application
                    Exec=hipchat4
                    Hidden=true
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=HipChat
                    Name=HipChat
                    Comment[en_US]=Auto launching HipChat
                    Comment=Auto launching HipChat
                    X-GNOME-Autostart-Delay=34"

                    "[Desktop Entry]
                    Type=Application
                    Exec=keepassx
                    Hidden=true
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=KeePassX
                    Name=KeePassX
                    Comment[en_US]=Auto launching KeePassX
                    Comment=Auto launching KeePassX
                    X-GNOME-Autostart-Delay=5"

                    "[Desktop Entry]
                    Type=Application
                    Exec=thunderbird
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Mozilla Thunderbird
                    Name=Mozilla Thunderbird
                    Comment[en_US]=Auto launching Mozilla Thunderbird
                    Comment=Auto launching Mozilla Thunderbird
                    X-GNOME-Autostart-Delay=15"

                    "[Desktop Entry]
                    Name=asbru-cm
                    Comment=Perl Auto Connector (auto start)
                    Terminal=false
                    Icon=asbru-cm
                    Type=Application
                    Exec=/usr/bin/asbru-cm --no-splash --iconified
                    StartupNotify=false
                    Name[en_US]=asbru-cm
                    Comment[en_US]=Perl Auto Connector (auto start)
                    Categories=Applications;Network;
                    X-GNOME-Autostart-enabled=true"

                    "[Desktop Entry]
                    Comment=Launches TeamDrive
                    Encoding=UTF-8
                    Exec=\"/opt/teamdrive/TeamDrive\" \"autostart\"
                    Name=Launch TeamDrive
                    Type=Application
                    Version=1.0
                    X-GNOME-Autostart-enabled=true"

                    "[Desktop Entry]
                    Exec=evolution
                    Type=Application
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Evolution
                    Name=Evolution
                    Comment[en_US]=Autostart Evolution Mail Client
                    Comment=Autostart Evolution Mail Client"

                    "[Desktop Entry]
                    Type=Application
                    Exec=hexchat
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=HexChat
                    Name=HexChat
                    Comment[en_US]=Autostart HexChat
                    Comment=Autostart HexChat"

                    "[Desktop Entry]
                    Type=Application
                    Exec=nitrokey-app
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=NitroKey
                    Name=NitroKey
                    Comment[en_US]=Autostart NitroKey
                    Comment=Autostart NitroKey"

                    "[Desktop Entry]
                    Type=Application
                    Exec=deluge-gtk
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Deluge
                    Name=Deluge
                    Comment[en_US]=Autostart Deluge
                    Comment=Autostart Deluge"

                    "[Desktop Entry]
                    Version=1.0
                    Name=Remmina Applet
                    Comment=Connect to remote desktops through the applet menu
                    Icon=remmina
                    Exec=remmina -i
                    Terminal=false
                    Type=Application
                    Hidden=false"

                    "[Desktop Entry]
                    Type=Application
                    Exec=digitalocean-indicator
                    Icon=digitalocean-indicator
                    Name=Digitalocean Indicator
                    Comment=Monitor your droplets
                    X-GNOME-Autostart-enabled=true"

                    "[Desktop Entry]
                    Type=Application
                    Vestion=1.0
                    Name=Gitter
                    Comment=Gitter startup script
                    Exec=/opt/Gitter/linux64/Gitter
                    StartupNotify=false"

                    "[Desktop Entry]
                    Type=Application
                    Exec=keepassxc
                    Hidden=true
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=KeePassXC
                    Name=KeePassXC
                    Comment[en_US]=Autostarting at OS boot
                    Comment=Launching KeePassXC"

                    "[Desktop Entry]
                    Type=Application
                    Version=1.0
                    Name=mattermost-desktop
                    Comment=mattermost-desktopstartup script
                    Exec=/opt/Mattermost/mattermost-desktop --hidden
                    StartupNotify=false
                    Terminal=false"

                    "[Desktop Entry]
                    Type=Application
                    Exec=stride
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=stride
                    Name=stride
                    Comment[en_US]=Autostarting at OS boot
                    Comment=launch stride"


);

                  # There is no autostart directory, so we are going to make it
                  mkdir '$hm'/'$usr'/.config/autostart;

                  # The loop
                  echo -e "Setting Startup GUI Applications: ";

                  for j in ${!appshrt[*]}; do
                    echo -e "\e[1m\e[32m"${appshrt[$j]}"\e[0m";
                    echo "${appshrt2[$j]}" > '$hm'/'$usr'/.config/autostart/"${appshrt[$j]}";
                  done

                  exit'

                  blnk_echo;

                  # END: Startup Applications (GUI)


                  # Miscellaneous
                  sctn_echo MISCELLANEOUS;

                  # Enabling powerline
                  # Getting the names of the existed "human" users by looking at the names of the folders (full path) in the /home directory, as well as manually adds the root user to the extracted list
                  gui_user=$(ls -d -1 /home/** && echo "/root");
                  # Inserts the powerline commands in .bashrc of the each user found in the /home folder
                  # @NOTE verify onwer of the .bashrc file
                  for l in $gui_user; do
                  echo "if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
                      source /usr/share/powerline/bindings/bash/powerline.sh
                  fi" >> $l/.bashrc;
                  done

                  # Removing unnecessary apps
                  # list of the packages that are going to be removed
                  remapp="shotwell transmission*";

                  echo "Removing package(s):";
                  # The main multi-loop for installing apps/libs
                  for k in $remapp; do
                    echo -e "\e[1m\e[34m$k\e[0m";
                    # apt-get -yqq remove $k > /dev/null 2>&1;
                    apt-get -yqq purge $k > /dev/null 2>&1;
                  done

                  blnk_echo;


                  # Starting a $usr subshell
                  sudo -Hu "$usr" bash -c '

                  # Creating necessary folders as a simple user
                  fldrs=( "Tests Drives/VirtualBox Projects/CJI Public/GIT"/{GitHub,GitLab,BitBucket} );
                  for l in ${fldrs[@]}; do
                  mkdir -p '$hm'/'$usr'/$l;
                  done

                  # Disabling Nautilus feature of automatically opening folders when something is mounted
                  gsettings set org.gnome.desktop.media-handling automount-open false

                  # Nautilus
                  gsettings set org.gnome.nautilus.preferences click-policy "single"
                  gsettings set org.gnome.nautilus.preferences enable-delete true
                  gsettings set org.gnome.nautilus.preferences confirm-trash false
                  gsettings set org.gnome.nautilus.preferences enable-interactive-search false

                  # Gnome Settings
                  gsettings set org.gnome.desktop.media-handling automount-open false
                  gsettings set com.canonical.indicator.datetime show-auto-detected-location true
                  gsettings set com.canonical.indicator.datetime show-date true
                  gsettings set com.canonical.indicator.datetime show-day true
                  gsettings set com.canonical.indicator.datetime show-events true
                  gsettings set com.canonical.indicator.datetime show-locations true
                  gsettings set com.canonical.indicator.datetime show-seconds true
                  gsettings set com.canonical.indicator.datetime time-format '24-hour'
                  gsettings set org.gnome.desktop.datetime automatic-timezone true
                  gsettings set org.gnome.desktop.interface clock-format '24h'

                  # gsettings set com.canonical.indicator.datetime custom-time-format '%l:%M %p'
                  # gsettings set com.canonical.indicator.datetime show-calendar true
                  # gsettings set com.canonical.indicator.datetime show-clock true
                  # gsettings set com.canonical.indicator.datetime show-week-numbers false
                  # gsettings set com.canonical.indicator.datetime show-year true
                  # gsettings set com.canonical.indicator.datetime timezone-name ''

                  # gEdit
                  gsettings set org.gnome.gedit.preferences.editor auto-save true
                  gsettings set org.gnome.gedit.preferences.editor auto-save-interval 1
                  gsettings set org.gnome.gedit.preferences.editor create-backup-copy true
                  gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
                  gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
                  gsettings set org.gnome.gedit.preferences.editor scheme "'oblivion'"
                  gsettings set org.gnome.gedit.preferences.editor tabs-size 2
                  gsettings set org.gnome.gedit.preferences.editor bracket-matching true
                  gsettings set org.gnome.gedit.preferences.editor insert-spaces true
                  gsettings set org.gnome.gedit.preferences.ui statusbar-visible true
                  gsettings set org.gnome.gedit.preferences.editor display-overview-map true
                  gsettings set org.gnome.gedit.preferences.editor auto-indent true


                  gsettings set com.canonical.indicator.bluetooth visible false
                  rfkill block bluetooth
                  # rfkill unblock bluetooth
                  gsettings set com.canonical.desktop.interface scrollbar-mode normal


                  # Unity
                  dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 40
                  dconf write /org/compiz/profiles/unity/plugins/unityshell/launcher-hide-mode 1
                  dconf write /org/compiz/profiles/unity/plugins/unityshell/edge-responsiveness 1.3


                  # 4 Workspaces run twice
                  dconf write /org/compiz/profiles/unity-lowgfx/plugins/core/hsize 4
                  dconf write /org/compiz/profiles/unity/plugins/core/hsize 4
                  dconf write /org/compiz/profiles/unity-lowgfx/plugins/core/vsize 1
                  dconf write /org/compiz/profiles/unity/plugins/core/vsize 1


                  # Lock the screen delay for 3 minutes
                  gsettings set org.gnome.desktop.session idle-delay 180


                  # Unity online search
                  gsettings set com.canonical.Unity.Lenses remote-content-search 'all'
                  # gsettings set com.canonical.Unity.Lenses remote-content-search 'none'


                  # Keyboard layouts
                  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ro+std'), ('xkb', 'ru')]"


                  # Mouse pointer speed
                  gsettings set org.gnome.desktop.peripherals.mouse speed '-0.58676470588235297'


                  # Sound: Allow louder than 100%
                  gsettings set com.ubuntu.sound allow-amplified-volume true


                  # Set timezone to Chisinau
                  gsettings set com.canonical.indicator.datetime timezone-name 'Europe/Chisinau Chisinau'


                  # Set changing backgrounds
                  gsettings set org.gnome.desktop.background picture-options 'file:///usr/share/backgrounds/contest/xenial.xml'

                  exit'

                  blnk_echo;

                  # The End of the $usr subshell

                  # Switching Fn keys to "normal" behaviour on an Apple keyboard
                  echo "options hid_apple iso_layout=0 fnmode=2" > /etc/modprobe.d/hid_apple.conf

                  # Another subshell
                  # @TODO Need to find a way to insert this subshell into the one above this one :)
                  # @TODO Alos hvae to figure out how to format hits text with tabs so that the commands below this subshell are execute correctly
                  sudo -Hu "$usr" bash -c 'cat > ~/.gitconfig' << EOF
# This is Gits per-user configuration file.
[user]
# Please adapt and uncomment the following lines:
name = $nme
email = $eml
EOF
                  # The End of the another $usr subshell
                  # END: Miscellaneous


                  sctn_echo FINAL ADJUSTMENTS
                  echo "Autoremoving unused packages ...";
                  apt-get -yqq autoremove > $dn >> $rlog;
                  blnk_echo;

                  # for lxd
                  usermod --append --groups lxd $usr > $dn >> $rlog;

    echo "Deleting the doubled Skype repository"
          rm -f /etc/apt/sources.list.d/skype-stable.list
    
                  newgrp lxd > $dn >> $rlog;

                  echo "Deleting temporary directory created at the beginning of this script ...";
                  cd / && rm -rf $tmpth;
                  blnk_echo;

                  echo -e "\e[1m\e[32mThe post installation finished.\e[0m";
                  echo -e "\e[1m\e[34mIt is better to restart the system.\e[0m";

                  blnk_echo;

                  sctn_echo REBOOT
                  echo -e "\n\e[1m\e[32mDo you wish to restart the system right now?\e[0m" && PS3='
                  Choose the answer: '
                  options=("Yes" "No")
                  select opt in "${options[@]}"
                  do
                      case $opt in
                          "Yes")
                              reboot;
                              exit
                              ;;
                          "No")
                              break
                              ;;
                          *) echo -e "\e[1m\e[31mYou have chosen an unexisted option.\e[0m";;
                      esac
                  done && echo -e "\e[1m\e[32mThank you.\e[0m";


                  # TODO verify installed apps - loop

                  # TODO Set applications to startup at boot minimized



                else
                  notrun DNSCrypt-Proxy;
                  echo -e "Maybe the chosen DNS Provider \e[1m\e[31m$dns_provider\e[0m was not saved successfully.\e[0m"
                  std_echo;
                fi

              else
                nofile_echo $dnscr_cfg;
                std_echo;
              fi

            else
              notrun DNSCrypt-Proxy;
              std_echo;
            fi



          else
          netconof_echo;
          std_echo;
          fi

        else
          notrun ufw;
          std_echo;
        fi

      else
        nofile_echo $ufwc;
        std_echo;
      fi


  else
  nofile_echo $srclst;
  std_echo;
  fi


else
  netconon_echo;
  std_echo;
fi
# END CONFIGURATION SECTION
# ----------------------------------
