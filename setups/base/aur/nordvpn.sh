#!/bin/bash
set -eu

sudo usermod -aG nordvpn "${USER}"

sudo systemctl enable --now nordvpnd

sg nordvpn -c "nordvpn set technology nordlynx"

exit 0
