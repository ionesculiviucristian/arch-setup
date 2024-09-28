#!/bin/bash
set -eu

# [Config] http://www.proftpd.org/docs/howto/ConfigFile.html

export USER="${USER}"
GROUP="$(id -gn "${USER}")"
export GROUP

envsubst < "./configs/etc/proftpd.conf.stub" | \
  sudo tee "/etc/proftpd.conf" >/dev/null

./scripts/update_hosts.sh "127.0.0.1 ftp.localdev"

sudo iptables -I INPUT 1 -p tcp -s 127.0.0.1 --dport 21 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 21 -j DROP

sudo systemctl enable proftpd.service
sudo systemctl start proftpd.service

exit 0
