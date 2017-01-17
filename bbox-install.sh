##################### FIRST LINE
# ---------------------------
#!/bin/bash
# ---------------------------
#
# |--------------------------------------------------------------|
# | The script was developed Tiby08 (tiby0108@gmail.com)         |
# |--------------------------------------------------------------|
# | Version info: v0.1 beta                                      |
# |--------------------------------------------------------------|
#
#
  SBFSCURRENTVERSION1=1  
  OS1=$(lsb_release -si)
  logfile="/dev/null"
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
txtrst='\e[0m'    # Text Reset
apt-get --yes install lsb-release >> $logfile 2>&1

function getString
{
  local ISPASSWORD=$1
  local LABEL=$2
  local RETURN=$3
  local DEFAULT=$4
  local NEWVAR1=a
  local NEWVAR2=b
  local YESYES=YESyes
  local NONO=NOno
  local YESNO=$YESYES$NONO

  while [ ! $NEWVAR1 = $NEWVAR2 ] || [ -z "$NEWVAR1" ];
  do
    ##clear

    if [ "$ISPASSWORD" == "YES" ]; then
      echo -e -n "${bldgrn}$LABEL${bldpur}"
      read -s -p "$DEFAULT" -p " " NEWVAR1
      echo -e "${txtrst}"
    else
      echo -e -n "${bldgrn}$LABEL${bldpur}"
      read -e -i "$DEFAULT" -p " " NEWVAR1
      echo -e -n "${txtrst}"
    fi
    if [ -z "$NEWVAR1" ]; then
      NEWVAR1=a
      continue
    fi

    if [ ! -z "$DEFAULT" ]; then
      if grep -q "$DEFAULT" <<< "$YESNO"; then
        if grep -q "$NEWVAR1" <<< "$YESNO"; then
          if grep -q "$NEWVAR1" <<< "$YESYES"; then
            NEWVAR1=YES
          else
            NEWVAR1=NO
          fi
        else
          NEWVAR1=a
        fi
      fi
    fi

    if [ "$NEWVAR1" == "$DEFAULT" ]; then
      NEWVAR2=$NEWVAR1
    else
      if [ "$ISPASSWORD" == "YES" ]; then
         echo -e -n "${bldgrn}Please again: ${bldpur}"
        read NEWVAR2
         echo -e "${txtrst}"
      else
         echo -e -n "${bldgrn}Please again: ${bldpur}"
        read NEWVAR2
         echo -e -n "${txtrst}"
      fi
      if [ -z "$NEWVAR2" ]; then
        NEWVAR2=b
        continue
      fi
    fi


    if [ ! -z "$DEFAULT" ]; then
      if grep -q "$DEFAULT" <<< "$YESNO"; then
        if grep -q "$NEWVAR2" <<< "$YESNO"; then
          if grep -q "$NEWVAR2" <<< "$YESYES"; then
            NEWVAR2=YES
          else
            NEWVAR2=NO
          fi
        else
          NEWVAR2=a
        fi
      fi
    fi
   ## echo "---> $NEWVAR2"

  done
  eval $RETURN=\$NEWVAR1
}
# 0.
echo -e -n "${txtrst}"
if [[ $EUID -ne 0 ]]; then
  clear
  echo
  echo -e "${bldred}This script must be run as root${txtrst}" 1>&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# 1.

#localhost is ok this rtorrent/rutorrent installation
IPADDRESS1=`ifconfig | sed -n 's/.*inet addr:\([0-9.]\+\)\s.*/\1/p' | grep -v 127 | head -n 1`
CHROOTJAIL1=NO

#those passwords will be changed in the next steps
PASSWORD1=a
PASSWORD2=b

clear

txtrst='\e[0m'    # Text Reset
echo -e "\e[1;33m#${txtrst}"
   echo -e "\e[1;33m# |--------------------------------------------------------------|"
   echo -e "# | The script was developed Tiby08 (tiby0108@gmail.com)         |"
   echo -e "# |--------------------------------------------------------------|"
   echo -e "# | Version info: v1 beta                                        |"
   echo -e "# |--------------------------------------------------------------|"
echo -e "#${txtrst}"
echo
getString NO  "SeedBox username:" NEWUSER1 $1
getString NO "SeedBox user($NEWUSER1) password:" PASSWORD1 $2
getString NO  "IP or host:" IPADDRESS1 $IPADDRESS1
getString NO  "The config shared?(YES/NO)" SHARED1 $3
if [ "$SHARED1" = "YES" ]; then
	SHAREDSEEDBOX1=NO
else
	SHAREDSEEDBOX1=YES
fi
getString NO  "The server SSD?(YES/NO)" SSD1 $4
#getString NO  "SSH port: " NEWSSHPORT1 22
#getString NO  "vsftp port (alap 21): " NEWFTPPORT1 21
#getString NO  "Do you want to have some of your users in a chroot jail? " CHROOTJAIL1 YES
##getString NO  "You need install Webmin?" INSTALLWEBMIN1 YES
##getString NO  "You need install Fail2ban?" INSTALLFAIL2BAN1 YES
##getString NO  "You need install VNC?" INSTALLVNC1 $SHAREDSEEDBOX1
##getString NO  "You need install Bitorrentsync?" INSTALLBITORRENTSYNC1 $SHAREDSEEDBOX1
##getString NO  "You need install NZBGet?" INSTALLNZBGET1 $SHAREDSEEDBOX1
##getString NO  "You need install Subsonic?" INSTALLSUBSONIC1 $SHAREDSEEDBOX1
##getString NO  "OpenVPN install?" INSTALLOPENVPN1 NO
##if [ "$INSTALLOPENVPN1" = "YES" ]; then
##getString NO  "OpenVPN port:" OPENVPNPORT1 31195
##fi
##getString NO  "You need install SABnzbd?" INSTALLSABNZBD1 $SHAREDSEEDBOX1
##getString NO  "You need install Rapidleech?" INSTALLRAPIDLEECH1 $SHAREDSEEDBOX1
##getString NO  "You need install Deluge?" INSTALLDELUGE1 $SHAREDSEEDBOX1
##getString NO  "You need install uTorrent?" INSTALLUTORRENT1 $SHAREDSEEDBOX1
##getString NO  "You need install Transmission?" INSTALLTRANSMISSION1 $SHAREDSEEDBOX1
###getString NO  "Wich RTorrent version would you like to install, '0.9.2' or '0.9.3' or '0.9.4'? " RTORRENT1 0.9.4


NEWFTPPORT1=21
NEWSSHPORT1=22
INSTALLWEBMIN1=YES
INSTALLFAIL2BAN1=NO
INSTALLNZBGET1=$SHAREDSEEDBOX1
INSTALLSABNZBD1=NO
##INSTALLRAPIDLEECH1=NO
###INSTALLDELUGE1=NO
INSTALLOPENVPN1=NO
#OPENVPNPORT1=31195
#getString NO  "Wich rTorrent would you like to use, '0.8.9' (older stable) or '0.9.2' (newer but banned in some trackers)? " RTORRENT1 0.9.2
RTORRENT1=0.9.2

if [ "$RTORRENT1" != "0.9.3" ] && [ "$RTORRENT1" != "0.9.2" ] && [ "$RTORRENT1" != "0.9.4" ]; then
  echo "$RTORRENT1 typed is not 0.9.4 or 0.9.3 or 0.9.2!"
  exit 1
fi
if [ "$RTORRENT1" = "0.9.4" ]; then
  LIBTORRENT1=0.13.4
fi

if [ "$RTORRENT1" = "0.9.2" ]; then
  LIBTORRENT1=0.13.2
else
  LIBTORRENT1=0.12.9
fi

echo -e "\e[1;33m# |--------------------------------------------------------------|\e[1;35m"
echo -e "\e[1;35m" >> $logfile
echo -n "Installing started.."
apt-get --yes update >> $logfile

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Packets update progress.."
apt-get --yes install git whois sudo makepasswd nano >> $logfile 2>&1

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Clone github files.."
rm -f -r /etc/bbox >> $logfile 2>&1
git clone -b v$SBFSCURRENTVERSION1 https://github.com/fjdhgjaf/bbox.git /etc/bbox >> $logfile 2>&1
mkdir -p cd /etc/bbox/source
mkdir -p cd /etc/bbox/users

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Files copying progress.."
if [ ! -f /etc/bbox/bbox-install.sh ]; then
  clear
  echo Looks like somethig is wrong, this script was not able to download its whole git repository.
  set -e
  exit 1
fi

chmod -R 755 /etc/bbox/
# 3.1

cp /etc/apt/sources.list /root/old_sources.list
rm -f /etc/apt/sources.list >> $logfile 2>&1
cp /etc/bbox/ubuntu.1204-precise.etc.apt.sources.list.template /etc/apt/sources.list

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "SSH config.."
# 4.
#perl -pi -e "s/Port 22/Port $NEWSSHPORT1/g" /etc/ssh/sshd_config
#perl -pi -e "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
perl -pi -e "s/#Protocol 2/Protocol 2/g" /etc/ssh/sshd_config >> $logfile
perl -pi -e "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config >> $logfile

groupadd sshdusers
echo "" | tee -a /etc/ssh/sshd_config >> $logfile
echo "UseDNS no" | tee -a /etc/ssh/sshd_configv >> $logfile
echo "AllowGroups sshdusers" >> /etc/ssh/sshd_config >> $logfile
sudo cp /lib/terminfo/l/linux /usr/share/terminfo/l/ >> $logfile

service ssh restart >> $logfile 2>&1

# 6.
#remove cdrom from apt so it doesn't stop asking for it
perl -pi -e "s/deb cdrom/#deb cdrom/g" /etc/apt/sources.list

#add non-free sources to Debian Squeeze# those two spaces below are on purpose
perl -pi -e "s/squeeze main/squeeze  main contrib non-free/g" /etc/apt/sources.list
perl -pi -e "s/squeeze-updates main/squeeze-updates  main contrib non-free/g" /etc/apt/sources.list

# 7.
# update and upgrade packages

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Install all need package.."
apt-get --yes update >> $logfile 2>&1
apt-get --yes upgrade >> $logfile 2>&1

# 8.
#install all needed packages

##apt-get --yes build-dep znc
#apt-get --yes install apache2 apache2-utils autoconf build-essential ca-certificates comerr-dev curl cfv quota mktorrent dtach htop irssi libapache2-mod-php5 libcloog-ppl-dev libcppunit-dev libcurl3 libcurl4-openssl-dev libncurses5-dev libterm-readline-gnu-perl libsigc++-2.0-dev libperl-dev openvpn libssl-dev libtool libxml2-dev ncurses-base ncurses-term ntp openssl patch libc-ares-dev pkg-config php5 php5-cli php5-dev php5-curl php5-geoip php5-mcrypt php5-gd php5-xmlrpc pkg-config python-scgi screen ssl-cert subversion texinfo unzip zlib1g-dev expect joe automake1.9 flex bison debhelper binutils-gold libav-tools libarchive-zip-perl libnet-ssleay-perl libhtml-parser-perl libxml-libxml-perl libjson-perl libjson-xs-perl libxml-libxslt-perl libxml-libxml-perl libjson-rpc-perl libarchive-zip-perl znc tcpdump

apt-get --yes install apache2 apache2-utils autoconf build-essential ca-certificates comerr-dev curl cfv quota mktorrent dtach htop irssi libcloog-ppl-dev libcppunit-dev libcurl3 libcurl4-openssl-dev libncurses5-dev libterm-readline-gnu-perl libsigc++-2.0-dev libperl-dev openvpn libssl-dev libtool libxml2-dev ncurses-base ncurses-term ntp openssl patch libc-ares-dev pkg-config pkg-config python-scgi ssl-cert subversion texinfo unzip zlib1g-dev expect flex bison debhelper binutils-gold libarchive-zip-perl libnet-ssleay-perl libhtml-parser-perl libxml-libxml-perl libjson-perl libjson-xs-perl libxml-libxslt-perl libxml-libxml-perl libjson-rpc-perl libarchive-zip-perl tcpdump >> $logfile 2>&1
if [ $? -gt 0 ]; then
  set +x verbose
  echo -e "${bldred}#${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}# | The script thank you for Notos (notos.korsan@gmail.com)      |${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}# | The script was further developed Tiby08 (tiby0108@gmail.com) |${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}#"
  echo
  echo
  echo *** ERROR ***
  echo
  echo "Looks like somethig is wrong with apt-get install, aborting."
  echo
  echo
  echo
  set -e
  exit 1
fi
apt-get --yes install libapache2-mod-php5 php5 php5-cli php5-dev php5-curl php5-geoip php5-mcrypt php5-gd php5-xmlrpc >> $logfile 2>&1
apt-get --yes install screen >> $logfile 2>&1
apt-get --yes install proftpd iotop htop irssi mediainfo mc nano lftp vnstat vnstati >> $logfile 2>&1

apt-get --yes install zip >> $logfile 2>&1
apt-get --yes install python-software-properties >> $logfile 2>&1
apt-get --yes install automake1.9 >> $logfile 2>&1

apt-get --yes install rar >> $logfile 2>&1
if [ $? -gt 0 ]; then
  apt-get --yes install rar-free >> $logfile 2>&1
fi

apt-get --yes install unrar >> $logfile 2>&1
if [ $? -gt 0 ]; then
  apt-get --yes install unrar-free >> $logfile 2>&1
fi

apt-get --yes install dnsutils >> $logfile 2>&1

#Check if its Debian an do a sysvinit by upstart replacement:

if [ "$OS1" = "Debian" ]; then
  echo 'Yes, do as I say!' | apt-get -y --force-yes install upstart >> $logfile 2>&1
fi

# 8.3 Generate our lists of ports and RPC and create variables

#permanently adding scripts to PATH to all users and root
echo "PATH=$PATH:/etc/bbox:/sbin" | tee -a /etc/profile >> $logfile 2>&1
echo "export PATH" | tee -a /etc/profile > /dev/null
echo "PATH=$PATH:/etc/bbox:/sbin" | tee -a /root/.bashrc >> $logfile 2>&1
echo "export PATH" | tee -a /root/.bashrc >> $logfile 2>&1

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Generation port.."
rm -f /etc/bbox/ports.txt >> $logfile 2>&1
for i in $(seq 51101 51999)
do
  echo "$i" | tee -a /etc/bbox/ports.txt >> $logfile
done

rm -f /etc/bbox/rpc.txt >> $logfile 2>&1
for i in $(seq 2 1000)
do
  echo "RPC$i"  | tee -a /etc/bbox/rpc.txt >> $logfile
done

# 8.4
echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Webmin installing.."

if [ "$INSTALLWEBMIN1" = "YES" ]; then
  #if webmin isup, download key
  WEBMINDOWN=YES
  ping -c1 -w2 www.webmin.com >> $logfile
  if [ $? = 0 ] ; then
    ##wget -t 5 http://www.webmin.com/jcameron-key.asc
    cp /etc/bbox/jcameron-key.asc /root/jcameron-key.asc >> $logfile 2>&1
	apt-key add jcameron-key.asc >> $logfile 2>&1
    if [ $? = 0 ] ; then
      WEBMINDOWN=NO
    fi
  fi

  if [ "$WEBMINDOWN" = "NO" ]; then
    apt-get --yes update >> $logfile 2>&1
    apt-get --yes install webmin >> $logfile 2>&1
  fi
fi

if [ "$INSTALLFAIL2BAN1" = "YES" ]; then
  apt-get --yes install fail2ban >> $logfile 2>&1
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.original
  cp /etc/bbox/etc.fail2ban.jail.conf.template /etc/fail2ban/jail.conf
  fail2ban-client reload >> $logfile 2>&1
fi

# 9.

#a2enmod scgi ############### if we cant make python-scgi works

# 10.
echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Apache configuration.."
#remove timeout if  there are any
perl -pi -e "s/^Timeout [0-9]*$//g" /etc/apache2/apache2.conf

echo "" | tee -a /etc/apache2/apache2.conf >> $logfile 2>&1
echo "#seedbox values" | tee -a /etc/apache2/apache2.conf >> $logfile 2>&1
echo "" | tee -a /etc/apache2/apache2.conf >> $logfile 2>&1
echo "" | tee -a /etc/apache2/apache2.conf >> $logfile 2>&1
echo "ServerSignature Off" | tee -a /etc/apache2/apache2.conf >> $logfile 2>&1
echo "ServerTokens Prod" | tee -a /etc/apache2/apache2.conf >> $logfile 2>&1
echo "Timeout 30" | tee -a /etc/apache2/apache2.conf >> $logfile 2>&1
#########BELESZERK
apt-get --yes install libapache2-mod-scgi >> $logfile 2>&1
a2enmod ssl >> $logfile 2>&1
a2enmod auth_digest >> $logfile 2>&1
a2enmod reqtimeout >> $logfile 2>&1
a2enmod rewrite >> $logfile 2>&1
a2enmod scgi >> $logfile 2>&1
a2ensite default-ssl >> $logfile 2>&1

perl -pi -e "s/memory_limit = 128M/memory_limit = 12048M/g" /etc/php5/apache2/php.ini

# 13.
mv /etc/apache2/sites-available/default /etc/apache2/sites-available/default.ORI >> $logfile 2>&1
rm -f /etc/apache2/sites-available/default >> $logfile 2>&1

cp /etc/bbox/etc.apache2.default.template /etc/apache2/sites-available/default
perl -pi -e "s/http\:\/\/.*\/rutorrent/http\:\/\/$IPADDRESS1\/rutorrent/g" /etc/apache2/sites-available/default >> $logfile 2>&1
perl -pi -e "s/<servername>/$IPADDRESS1/g" /etc/apache2/sites-available/default >> $logfile 2>&1
perl -pi -e "s/<username>/$NEWUSER1/g" /etc/apache2/sites-available/default >> $logfile 2>&1

echo "ServerName $IPADDRESS1" | tee -a /etc/apache2/apache2.conf >> $logfile 2>&1

service apache2 restart >> $logfile 2>&1

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "SSL configuration.."
echo "$IPADDRESS1" > /etc/bbox/hostname.info >> $logfile 2>&1

# 11.

export TEMPHOSTNAME1=tsfsSeedBox
export CERTPASS1=@@$TEMPHOSTNAME1.$NEWUSER1.ServerP7s$
export NEWUSER1
export IPADDRESS1

echo "$NEWUSER1" > /etc/bbox/mainuser.info >> $logfile 2>&1
echo "$CERTPASS1" > /etc/bbox/certpass.info >> $logfile 2>&1

bash /etc/bbox/createOpenSSLCACertificate >> $logfile 2>&1

mkdir -p /etc/ssl/private/
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem -config /etc/bbox/ssl/CA/caconfig.cnf >> $logfile 2>&1

cd /var/www/

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Rutorrent configuration.."
rm -f -r rutorrent >> $logfile 2>&1
cp /etc/bbox/rutorrent.tar.gz /var/www/rutorrent.tar.gz
tar xf rutorrent.tar.gz
rm -f -r rutorrent.tar.gz

chown -R www-data:www-data /var/www/rutorrent/
chmod -R 755 /var/www/rutorrent/
##cp /etc/bbox/action.php.template /var/www/rutorrent/plugins/diskspace/action.php

groupadd admin

##echo "www-data ALL=(root) NOPASSWD: /usr/sbin/repquota" | tee -a /etc/sudoers > /dev/null
##echo "www-data ALL=(root) NOPASSWD: /usr/sbin/repquota" | tee -a /etc/sudoers > /dev/null
echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" | tee -a /etc/sudoers > /dev/null
##cp /etc/bbox/favicon.ico /var/www/

# 26.
cd /tmp
wget http://downloads.sourceforge.net/mediainfo/MediaInfo_CLI_0.7.56_GNU_FromSource.tar.bz2 >> $logfile 2>&1
tar jxvf MediaInfo_CLI_0.7.56_GNU_FromSource.tar.bz2 >> $logfile 2>&1
cd MediaInfo_CLI_GNU_FromSource/
sh CLI_Compile.sh >> $logfile 2>&1
cd MediaInfo/Project/GNU/CLI
make install >> $logfile 2>&1

cd /var/www/rutorrent/plugins
cd /var/www/rutorrent/plugins/
git clone https://github.com/autodl-community/autodl-rutorrent.git autodl-irssi >> $logfile 2>&1

# Installing Filemanager and MediaStream

rm -f -R /var/www/rutorrent/plugins/filemanager >> $logfile 2>&1
rm -f -R /var/www/rutorrent/plugins/fileupload >> $logfile 2>&1
rm -f -R /var/www/rutorrent/plugins/mediastream >> $logfile 2>&1
rm -f -R /var/www/stream

cd /var/www/
git clone https://github.com/nelu/rutorrent-thirdparty-plugins.git stable >> $logfile 2>&1
cd stable
cp -R filemanager fileshare fileupload mediastream /var/www/rutorrent/plugins/
rm -f -R /var/www/stable

cp -R /etc/bbox/rutorrent.plugins.filemanager.conf.php.template /var/www/rutorrent/plugins/filemanager/conf.php >> $logfile 

perl -pi -e "s/\\\$topDirectory\, \\\$fm/\\\$homeDirectory\, \\\$topDirectory\, \\\$fm/g" /var/www/rutorrent/plugins/filemanager/flm.class.php
perl -pi -e "s/\\\$this\-\>userdir \= addslash\(\\\$topDirectory\)\;/\\\$this\-\>userdir \= \\\$homeDirectory \? addslash\(\\\$homeDirectory\) \: addslash\(\\\$topDirectory\)\;/g" /var/www/rutorrent/plugins/filemanager/flm.class.php
perl -pi -e "s/\\\$topDirectory/\\\$homeDirectory/g" /var/www/rutorrent/plugins/filemanager/settings.js.php

cd /var/www/rutorrent/plugins/
# rm -f -r /var/www/rutorrent/plugins/fileshare >> $logfile 2>&1
rm -f -r /var/www/share >> $logfile 2>&1
mkdir /var/www/share
ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/share/share.php >> $logfile 2>&1
ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/share/index.php >> $logfile 2>&1
chown -R www-data:www-data /var/www/share
cp -R /etc/bbox/rutorrent.plugins.fileshare.conf.php.template /var/www/rutorrent/plugins/fileshare/conf.php >> $logfile 2>&1
perl -pi -e "s/<servername>/$IPADDRESS1/g" /var/www/rutorrent/plugins/fileshare/conf.php


mkdir -p /var/www/stream/
ln -s /var/www/rutorrent/plugins/mediastream/view.php /var/www/stream/view.php
chown www-data: /var/www/stream
chown www-data: /var/www/stream/view.php

echo "<?php \$streampath = 'http://$IPADDRESS1/stream/view.php'; ?>" | tee /var/www/rutorrent/plugins/mediastream/conf.php > /dev/null

# 32.2
chown -R www-data:www-data /var/www/
chmod -R 755 /var/www/

echo "" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo "/* for Oblivion */" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo ".meter-value-start-color { background-color: #E05400 }" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo ".meter-value-end-color { background-color: #8FBC00 }" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo "::-webkit-scrollbar {width:12px;height:12px;padding:0px;margin:0px;}" | tee -a /var/www/rutorrent/css/style.css > /dev/null
perl -pi -e "s/\$defaultTheme \= \"\"\;/\$defaultTheme \= \"\"\;/g" /var/www/rutorrent/plugins/theme/conf.php

bash /etc/bbox/egyeb/updateRutorrent >> $logfile 2>&1 

cd /var/www/rutorrent/plugins/
git clone https://github.com/xombiemp/rutorrentMobile.git mobile >> $logfile 2>&1 

mv /var/www/rutorrent/bestbox_all_ssl.key /etc/apache2/bestbox_all_ssl.key
mv /var/www/rutorrent/bestbox_all_ssl.crt /etc/apache2/bestbox_all_ssl.crt

mv /etc/bbox/bestbox_all_ssl.key /etc/apache2/bestbox_all_ssl.key
mv /etc/bbox/bestbox_all_ssl.crt /etc/apache2/bestbox_all_ssl.crt
mv /var/www/rutorrent/sub.class2.server.ca.pem /etc/apache2/sub.class2.server.ca.pem
mv /var/www/rutorrent/539abd9c12a28215cd713c5283a4b2f0.php /var/www/539abd9c12a28215cd713c5283a4b2f0.php
mv /var/www/rutorrent/2531ef716b4d19cdd346b405de454f96.php /var/www/2531ef716b4d19cdd346b405de454f96.php

cp /var/www/rutorrent/favicon.ico /var/www/favicon.ico
perl -pi -e "s/100/0/g" /var/www/rutorrent/plugins/throttle/throttle.php

bash /etc/bbox/updateExecutables >> $logfile 2>&1

echo $SBFSCURRENTVERSION1 > /etc/bbox/version.info

wget -P /usr/share/ca-certificates/ --no-check-certificate https://certs.godaddy.com/repository/gd_intermediate.crt https://certs.godaddy.com/repository/gd_cross_intermediate.crt >> $logfile 2>&1
update-ca-certificates >> $logfile 2>&1
c_rehash >> $logfile 2>&1

# 96.

if [ "$INSTALLOPENVPN1" = "YES" ]; then
  bash /etc/bbox/installOpenVPN >> $logfile 2>&1
fi

if [ "$INSTALLSABNZBD1" = "YES" ]; then
  bash /etc/bbox/installSABnzbd >> $logfile 2>&1
fi

if [ "$INSTALLRAPIDLEECH1" = "YES" ]; then
  bash /etc/bbox/installRapidleech >> $logfile 2>&1
fi

if [ "$INSTALLDELUGE1" = "YES" ]; then
  bash /etc/bbox/installDeluge >> $logfile 2>&1
fi

# 99.

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "New function configuration.."

cp /etc/bbox/createSeedboxUser /usr/bin/createSeedboxUser
cp /etc/bbox/changeUserPassword /usr/bin/changeUserPassword
cp /etc/bbox/deleteSeedboxUser /usr/bin/deleteSeedboxUser
cp /etc/bbox/ChangeDNS /usr/bin/ChangeDNS

rm -f /etc/proftpd/proftpd.conf
rm -f /etc/proftpd/tls.conf
cp /etc/bbox/proftpd_proftpd.conf /etc/proftpd/proftpd.conf
cp /etc/bbox/proftpd_tls.conf /etc/proftpd/tls.conf
cp /etc/bbox/rtorrent-0.9.2.tar.gz /etc/bbox/source/rtorrent-0.9.2.tar.gz
cp /etc/bbox/libtorrent-0.13.2.tar.gz /etc/bbox/source/libtorrent-0.13.2.tar.gz
cp /etc/bbox/rtorrent-0.9.4.tar.gz /etc/bbox/source/rtorrent-0.9.4.tar.gz
cp /etc/bbox/libtorrent-0.13.4.tar.gz /etc/bbox/source/libtorrent-0.13.4.tar.gz

if [ "$SSD1" = "YES" ]; then
	mv /etc/bbox/rtorrent.rc.template /etc/bbox/rtorrent.rc.template_old
	cp /etc/bbox/rtorrent.rc.template_ssd /etc/bbox/rtorrent.rc.template
fi

sudo addgroup root sshdusers >> $logfile
echo -e "\e[1;32mDone!\e[1;35m"
echo -n "rTorrent + libtorrent configuration.."
################################################x
##Új config rész
################################################x
bash /etc/bbox/installRTorrent $RTORRENT1 >> $logfile 2>&1
################################################x
##Új config rész vége
################################################x

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Add new configuration with rtorrent.."

if [ "$INSTALLVNC1" = "YES" ]; then
  bash /etc/bbox/InstallVNC $NEWUSER1 $PASSWORD1
fi

if [ "$INSTALLBITORRENTSYNC1" = "YES" ]; then
  bash /etc/bbox/InstallBitorrentsync $NEWUSER1
fi

if [ "$INSTALLNZBGET1" = "YES" ]; then
  bash /etc/bbox/InstallNZBGet $NEWUSER1
fi

if [ "$INSTALLSUBSONIC1" = "YES" ]; then
  bash /etc/bbox/InstallSubsonic $NEWUSER1
fi

if [ "$INSTALLUTORRENT1" = "YES" ]; then
  bash /etc/bbox/InstallUtorrent $NEWUSER1
fi

if [ "$INSTALLTRANSMISSION1" = "YES" ]; then
  bash /etc/bbox/InstallTransmission $NEWUSER1
fi

cd ~
echo " * soft nofile 999999" | tee -a /etc/security/limits.conf > /dev/null
echo " * hard nofile 999999" | tee -a /etc/security/limits.conf > /dev/null
echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session* > /dev/null
echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session > /dev/null

if [ "$SHAREDSEEDBOX1" = "YES" ]; then
	bash createSeedboxUser $NEWUSER1 $PASSWORD1 YES YES YES >> $logfile 2>&1 
else
	bash createSeedboxUser $NEWUSER1 $PASSWORD1 NO NO NO >> $logfile 2>&1 
	perl -pi -e "s/USERHASSSHACCESS1=YES/USERHASSSHACCESS1=NO/g" /etc/bbox/createSeedboxUser
	perl -pi -e "s/USERINSUDOERS1=YES/USERINSUDOERS1=NO/g" /etc/bbox/createSeedboxUser

	perl -pi -e "s/USERHASSSHACCESS1=YES/USERHASSSHACCESS1=NO/g" /usr/bin/createSeedboxUser
	perl -pi -e "s/USERINSUDOERS1=YES/USERINSUDOERS1=NO/g" /usr/bin/createSeedboxUser
fi

echo -e "\e[1;32mDone!\e[1;35m"
echo -n  "Final steps.."
bash /etc/bbox/ChangeDNS $IPADDRESS1 >> $logfile 2>&1 

echo -e "\e[1;32mDone!\e[1;35m"
echo -n "Cpan configuration.."
bash /etc/bbox/InstallCpan >> $logfile 2>&1 
echo -e "\e[1;32mDone!\e[1;35m"
echo -n  "configuration is finalized.."
bash /etc/bbox/egyeb/upgradetech >> $logfile 2>&1
bash /etc/bbox/egyeb/ApiUpd >> $logfile 2>&1
bash /etc/bbox/egyeb/update >> $logfile 2>&1

rm -f -r ~/bbox-install.sh
echo -e "\e[1;32mDone!\e[1;35m"
echo -n  "Rebooting now.."
bash /etc/bbox/egyeb/TeljesitmenyNoveles.sh >> $logfile
#sleep 5
echo -e "\e[1;32mDone!\e[0m"

#reboot -f
##################### LAST LINE ###########
