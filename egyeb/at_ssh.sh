#!/bin/bash

fnev="<fnev>"
jelszo="<jelszo>"
host="<host>.bestbox.be"
tavoli_mappa="/<fnev>/"
helyi_mappa="/var/www/rutorrent/share/users/<fnev>/"
###/var/www/rutorrent/share/users/<fnev>/
###/home/<fnev>/downloads/manual/
###/home/<fnev>/downloads/.session/

trap "rm -f /tmp/<fnev>.lock" SIGINT SIGTERM

if [ -e /tmp/<fnev>.lock ]
then
  echo "Synctorrent(<fnev>) is running already."
  exit 1
else

  rm -f /tmp/<fnev>.lock

lftp -p 22 -u "$fnev","$jelszo" sftp://"$host" << EOF
	set sftp:auto-confirm yes
	set mirror:use-pget-n 5
	mirror -R -c -P5  "$helyi_mappa" "$tavoli_mappa"
	quit
EOF

  rm -f /tmp/<fnev>.lock
  exit 0

fi
