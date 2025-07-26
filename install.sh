#!/bin/bash
set -eu

# ==========================================
# Pre install
# ==========================================

PASSWORDLESS_SUDO="/etc/sudoers.d/$(whoami)"

echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "${PASSWORDLESS_SUDO}"

cp "./configs/.bashrc" "${HOME}/.bashrc"

# ==========================================
# Install official packages
# ==========================================

# shellcheck disable=SC2046
sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/official.txt")

# ==========================================
# Setup system
# ==========================================

./setups/dirs.sh
./setups/wallpapers.sh
./setups/power.sh

# ==========================================
# Install external packages
# ==========================================

./installers/yay.sh
./installers/papirus_folders.sh

# ==========================================
# Install AUR packages
# ==========================================

# shellcheck disable=SC2046
yay \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/aur.txt")

# ==========================================
# Install fonts
# ==========================================

./setups/fonts.sh

# ==========================================
# Setup base packages
# ==========================================

./setups/base/grub.sh
./setups/base/kde.sh
./setups/base/konsole.sh
./setups/base/kscreenlocker.sh
./setups/base/night_color.sh
./setups/base/pacman.sh
./setups/base/sddm.sh

# ==========================================
# Setup official packages
# ==========================================

./setups/official/atuin.sh
./setups/official/bat.sh
./setups/official/broot.sh
./setups/official/btop.sh
./setups/official/cups.sh
./setups/official/direnv.sh
./setups/official/docker.sh
./setups/official/eza.sh
./setups/official/fzf.sh
./setups/official/kitty.sh
./setups/official/lazygit.sh
./setups/official/libreoffice.sh
./setups/official/mkcert.sh
./setups/official/neovim.sh
./setups/official/nvm.sh
./setups/official/obs_studio.sh
./setups/official/poetry.sh
./setups/official/pyenv.sh
./setups/official/qBittorrent.sh
./setups/official/reflector.sh "${REFLECTOR_COUNTRY}"
./setups/official/starship.sh
./setups/official/superfile.sh
./setups/official/tmux.sh
./setups/official/vim.sh
./setups/official/zoxide.sh

# ==========================================
# Setup AUR packages
# ==========================================

./setups/aur/bitwarden.sh
./setups/aur/blesh.sh
./setups/aur/proftpd.sh
./setups/aur/tdrop.sh

# ==========================================
# Post install
# ==========================================

./scripts/update_bashrc.sh '[[ ${BLE_VERSION-} ]] && ble-attach'

./setups/base/bash.sh

sudo rm "${PASSWORDLESS_SUDO}"
