#!/bin/bash
set -eu

sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved

sudo cp \
  "./configs/etc/dnsmasq.conf" \
  "/etc/dnsmasq.conf"

sudo systemctl enable dnsmasq.service
sudo systemctl start dnsmasq.service

sudo cp \
  "./configs/etc/NetworkManager/conf.d/dns.conf" \
  "/etc/NetworkManager/conf.d/dns.conf"

sudo systemctl restart NetworkManager

exit 0
