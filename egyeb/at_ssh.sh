##################### FIRST LINE
# ---------------------------
#!/bin/bash
# ---------------------------
#
# |--------------------------------------------------------------|
# | The script developed Tiby08 (tiby0108@gmail.com)             |
# |--------------------------------------------------------------|
# | Version info: v1 beta                                        |
# |--------------------------------------------------------------|
#

fnev="root"
jelszo="root_jelszo"
host="ip_cim"

tavoli_rutorrent_share_mappa="/var/www/rutorrent/share/users/"
tavoli_home_manual_mappa="/home/darkmaster/downloads/"
tavoli_home_session_mappa="/home/darkmaster/downloads/"

helyi_rutorrent_share_mappa="/var/www/rutorrent/share/users/darkmaster/"
helyi_home_manual_mappa="/home/darkmaster/downloads/manual/"
helyi_home_session_mappa="/home/darkmaster/downloads/.session/"

bldylw='\e[1;33m' # Yellow
bldgrn='\e[1;32m' # Green
txtrst='\e[0m'    # Text Reset

sudo apt-get install lftp --yes
trap "rm -f /tmp/root.lock" SIGINT SIGTERM

clear

echo -e "${bldylw}#${txtrst}"
   echo -e "${bldylw}# |--------------------------------------------------------------|${txtrst}"
   echo -e "${bldylw}# | The script developed Tiby08 (tiby0108@gmail.com)             |${txtrst}"
   echo -e "${bldylw}# |--------------------------------------------------------------|${txtrst}"
echo -e "${bldylw}#${txtrst}"
echo

if [ -e /tmp/root.lock ]
then
  echo "Synctorrent(root) is running already."
  exit 1
else

  rm -f /tmp/root.lock
echo -e "${bldylw}Rutorrent share mappa másolása folyamatban.. "
lftp -p 22 -u "$fnev","$jelszo" sftp://"$host" << EOF
	set mirror:use-pget-n 5
	mirror -R -c -P5  "$helyi_rutorrent_share_mappa" "$tavoli_rutorrent_share_mappa"
	quit
EOF

echo -e "${bldgrn}Kész!"
sleep 1
echo -e "${bldylw}Session mappa másolása folyamatban.. "

lftp -p 22 -u "$fnev","$jelszo" sftp://"$host" << EOF
	set mirror:use-pget-n 5
	mirror -R -c -P5  "$helyi_home_session_mappa" "$tavoli_home_session_mappa"
	quit
EOF

echo -e "${bldgrn}Kész!"
sleep 1
echo -e "${bldylw}Letöltések mappa másolása folyamatban.. "

lftp -p 22 -u "$fnev","$jelszo" sftp://"$host" << EOF
	set mirror:use-pget-n 5
	mirror -R -c -P5  "$helyi_home_manual_mappa" "$tavoli_home_manual_mappa"
	quit
EOF

echo -e "${bldgrn}Kész!"
echo -e -n "${txtrst}"
echo ""
  exit 0

fi
