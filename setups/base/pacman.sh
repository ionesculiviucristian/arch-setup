#!/bin/bash
set -eu

sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
