#!/bin/bash
set -eu

sudo cp "./configs/etc/proftpd.conf" "/etc/proftpd.conf"

echo "127.0.0.1 ftp.localdev" | sudo tee -a "/etc/hosts"

sudo iptables -I INPUT 1 -p tcp -s 127.0.0.1 --dport 21 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 21 -j DROP

sudo systemctl enable proftpd.service
sudo systemctl start proftpd.service

exit 0
