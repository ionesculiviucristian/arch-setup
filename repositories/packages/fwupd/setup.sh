#!/bin/bash
set -eu

# @see [wiki](https://wiki.archlinux.org/title/Fwupd)

sudo systemctl enable --now fwupd-refresh.timer

exit 0
