#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/installer.sh"

dnsmasq_file="/etc/dnsmasq.conf"

sudo_replace_text \
  "#port=5353" \
  "port=5353" \
  "${dnsmasq_file}"

sudo_replace_text \
  "#listen-address=" \
  "listen-address=127.0.0.1" \
  "${dnsmasq_file}"

sudo_replace_text \
  "#no-resolv" \
  "no-resolv" \
  "${dnsmasq_file}"

sudo_replace_text \
  "#no-hosts" \
  "no-hosts" \
  "${dnsmasq_file}"

sudo_replace_text \
  "#address=/double-click.net/127.0.0.1" \
  "address=/.localdev/127.0.0.1" \
  "${dnsmasq_file}" \
  "|"

sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq

exit 0



