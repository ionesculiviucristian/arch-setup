#!/bin/bash
set -eu

# [Config] https://wiki.archlinux.org/title/CUPS

sudo systemctl enable cups.service
sudo systemctl start cups.service

exit 0
