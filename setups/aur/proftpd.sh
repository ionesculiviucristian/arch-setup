#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

export USER="${USER}"
# shellcheck disable=SC2155
export GROUP="$(id -gn "${USER}")"

envsubst < "./configs/etc/proftpd.conf" | \
sudo tee "/etc/proftpd.conf" > /dev/null

echo "127.0.0.1 ftp.localdev" | sudo tee -a "/etc/hosts" 2>&1 | tee -a "./install.log" >/dev/null

sudo iptables -I INPUT 1 -p tcp -s 127.0.0.1 --dport 21 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 21 -j DROP

service_start proftpd.service 2>&1 | tee -a "./install.log" >/dev/null
service_enable proftpd.service

exit 0
