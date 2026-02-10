#!/bin/bash
set -eu

# [Config] https://wiki.archlinux.org/title/CUPS

sudo systemctl enable --now cups.service

exit 0
