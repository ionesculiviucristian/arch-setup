#!/bin/bash
set -eu

export USER="${USER}"
# shellcheck disable=SC2155
export GROUP="$(id -gn "${USER}")"

envsubst < "./configs/etc/proftpd.conf" | \
sudo tee "/etc/proftpd.conf" > /dev/null

echo "127.0.0.1 ftp.localdev" | sudo tee -a "/etc/hosts"

sudo iptables -I INPUT 1 -p tcp -s 127.0.0.1 --dport 21 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 21 -j DROP

sudo systemctl enable proftpd.service
sudo systemctl start proftpd.service

exit 0
