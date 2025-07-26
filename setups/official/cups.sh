#!/bin/bash
set -eu

# https://wiki.archlinux.org/title/CUPS

sudo systemctl enable cups.service 2>&1 | tee "./install.log"
sudo systemctl start cups.service

exit 0
