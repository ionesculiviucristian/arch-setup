#!/bin/bash
set -eu

# [config] http://www.proftpd.org/docs/howto/ConfigFile.html

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

export USER="${USER}"
GROUP="$(id -gn "${USER}")"
export GROUP

envsubst <"${root_dir}/repositories/packages/proftpd/config/proftpd.conf.stub" |
  sudo tee "/etc/proftpd.conf" >/dev/null

"${root_dir}/scripts/update_hosts.sh" "127.0.0.1 ftp.localdev"

sudo iptables -I INPUT 1 -p tcp -s 127.0.0.1 --dport 21 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 21 -j DROP

sudo systemctl enable --now proftpd.service

exit 0
