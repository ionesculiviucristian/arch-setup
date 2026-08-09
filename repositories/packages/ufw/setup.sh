#!/bin/bash
set -eu

# @see [config](https://wiki.archlinux.org/title/Uncomplicated_Firewall)

sudo ufw default deny incoming >/dev/null
sudo ufw default allow outgoing >/dev/null
sudo ufw limit 22/tcp >/dev/null
sudo ufw allow 1714:1764/tcp >/dev/null
sudo ufw allow 1714:1764/udp >/dev/null
sudo ufw --force enable >/dev/null

sudo systemctl enable --now ufw.service

exit 0
