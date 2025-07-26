#!/bin/bash
set -eu

message() {
  echo "$1"
}

# ==========================================
# Pre install
# ==========================================

PASSWORDLESS_SUDO_FILE="/etc/sudoers.d/$(whoami)"

sudo rm -f "${PASSWORDLESS_SUDO_FILE}"

message "Creating ${PASSWORDLESS_SUDO_FILE}..." \
  && echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee "${PASSWORDLESS_SUDO_FILE}"

# ==========================================
# Install official packages
# ==========================================

# shellcheck disable=SC2046
message "Installing official packages..." && sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/official.txt")

# ==========================================
# Setup system
# ==========================================

cp "./configs/.bashrc" "${HOME}/.bashrc"

message "Installing dirs..." && ./setups/dirs.sh
message "Installing fonts..." && ./setups/fonts.sh
message "Installing wallpapers..." && ./setups/wallpapers.sh
message "Installing power..." && ./setups/power.sh

# ==========================================
# Install external packages
# ==========================================

message "Installing yay..." && ./installers/yay.sh

# ==========================================
# Install AUR packages
# ==========================================

# shellcheck disable=SC2046
message "Installing AUR packages..." && yay \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/aur.txt")

# ==========================================
# Setup base packages
# ==========================================

message "Setup grub..." && ./setups/base/grub.sh
message "Setup kde..." && ./setups/base/kde.sh
message "Setup konsole..." && ./setups/base/konsole.sh
message "Setup kscreenlocker..." && ./setups/base/kscreenlocker.sh
message "Setup night_color..." && ./setups/base/night_color.sh
message "Setup pacman..." && ./setups/base/pacman.sh
message "Setup sddm..." && ./setups/base/sddm.sh

# ==========================================
# Setup official packages
# ==========================================

message "Setup atuin..." && ./setups/official/atuin.sh
message "Setup bat..." && ./setups/official/bat.sh
message "Setup broot..." && ./setups/official/broot.sh
message "Setup btop..." && ./setups/official/btop.sh
message "Setup cups..." && ./setups/official/cups.sh
message "Setup direnv..." && ./setups/official/direnv.sh
message "Setup docker..." && ./setups/official/docker.sh
message "Setup eza..." && ./setups/official/eza.sh
message "Setup fzf..." && ./setups/official/fzf.sh
message "Setup kitty..." && ./setups/official/kitty.sh
message "Setup lazygit..." && ./setups/official/lazygit.sh
message "Setup libreoffice..." && ./setups/official/libreoffice.sh
message "Setup mkcert..." && ./setups/official/mkcert.sh
message "Setup neovim..." && ./setups/official/neovim.sh
message "Setup nvm..." && ./setups/official/nvm.sh
message "Setup obs_studio..." && ./setups/official/obs_studio.sh
message "Setup poetry..." && ./setups/official/poetry.sh
message "Setup pyenv..." && ./setups/official/pyenv.sh
message "Setup qBittorrent..." && ./setups/official/qBittorrent.sh
message "Setup reflector..." && ./setups/official/reflector.sh
message "Setup starship..." && ./setups/official/starship.sh
message "Setup superfile..." && ./setups/official/superfile.sh
message "Setup tmux..." && ./setups/official/tmux.sh
message "Setup vim..." && ./setups/official/vim.sh
message "Setup zoxide..." && ./setups/official/zoxide.sh

# ==========================================
# Setup AUR packages
# ==========================================

message "Setup bitwarden..." && ./setups/aur/bitwarden.sh
message "Setup blesh..." && ./setups/aur/blesh.sh
message "Setup papirus_folders..." && ./setups/aur/papirus_folders.sh
message "Setup proftpd..." && ./setups/aur/proftpd.sh
message "Setup tdrop..." && ./setups/aur/tdrop.sh

# ==========================================
# Post install
# ==========================================

./scripts/update_bashrc.sh '[[ ${BLE_VERSION-} ]] && ble-attach'

message "Setup bash..." && ./setups/base/bash.sh

message "Removing ${PASSWORDLESS_SUDO_FILE}..." && sudo rm -f "${PASSWORDLESS_SUDO_FILE}"
