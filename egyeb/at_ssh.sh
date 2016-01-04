#!/bin/bash

fnev="syssy"
jelszo="qN0wwxzx3jRY5zNOK"
host="best7.bestbox.be"
tavoli_mappa="/syssy/"
helyi_mappa="/var/www/rutorrent/share/users/syssy/"
###/var/www/rutorrent/share/users/syssy/
###/home/syssy/downloads/manual/
###/home/syssy/downloads/.session/

trap "rm -f /tmp/syssy.lock" SIGINT SIGTERM

if [ -e /tmp/syssy.lock ]
then
  echo "Synctorrent(syssy) is running already."
  exit 1
else

  rm -f /tmp/syssy.lock

lftp -p 22 -u "$fnev","$jelszo" sftp://"$host" << EOF
	set sftp:auto-confirm yes
	set mirror:use-pget-n 5
	mirror -R -c -P5  $helyi_mappa $tavoli_mappa
	quit
EOF

  rm -f /tmp/syssy.lock
  exit 0

fi
