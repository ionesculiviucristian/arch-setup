#!/bin/bash
set -eu

./install_themes.sh

echo "Updating mgitstatus"
rm -rf "${HOME}/.repos/multi-git-status"
git clone https://github.com/fboender/multi-git-status "${HOME}/.repos/multi-git-status"
cd "${HOME}/.repos/multi-git-status"
sudo make install

echo "Updating nvm"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

echo "Updating poetry"
poetry self update

echo "Updating ble.sh"
echo "Update manually using ble-update"
