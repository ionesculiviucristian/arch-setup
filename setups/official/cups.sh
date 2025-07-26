#!/bin/bash
set -eu

# https://wiki.archlinux.org/title/CUPS

sudo systemctl enable cups.service 2>&1 | tee -a "./install.log" >/dev/null
sudo systemctl start cups.service

exit 0
