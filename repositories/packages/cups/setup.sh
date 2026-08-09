#!/bin/bash
set -eu

# @see [config](https://wiki.archlinux.org/title/CUPS)

sudo systemctl enable --now cups.service

exit 0
