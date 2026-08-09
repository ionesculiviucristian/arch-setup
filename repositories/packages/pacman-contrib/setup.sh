#!/bin/bash
set -eu

# @see [config](https://man.archlinux.org/man/paccache.8)

sudo systemctl enable --now paccache.timer

exit 0
