#!/bin/bash
set -eu

# [config] https://wiki.archlinux.org/title/CUPS

sudo systemctl enable --now cups.service

exit 0
