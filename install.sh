#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/messages.sh"

# ==========================================
# Pre install
# ==========================================

PASSWORDLESS_SUDO_FILE="/etc/sudoers.d/$(whoami)"

sudo rm -f "${PASSWORDLESS_SUDO_FILE}"

info_msg "Creating ${PASSWORDLESS_SUDO_FILE}..." \
  && echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee "${PASSWORDLESS_SUDO_FILE}"

# ==========================================
# Install official packages
# ==========================================

# shellcheck disable=SC2046
install_msg "official packages" && sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/official.txt") >/dev/null

# ==========================================
# Setup system
# ==========================================

cp "./configs/.bashrc" "${HOME}/.bashrc"

setup_msg "dirs" && ./setups/dirs.sh
setup_msg "fonts" && ./setups/fonts.sh
setup_msg "wallpapers" && ./setups/wallpapers.sh
setup_msg "power" && ./setups/power.sh

# ==========================================
# Install external packages
# ==========================================

install_msg "yay" && ./installers/yay.sh

# ==========================================
# Install AUR packages
# ==========================================

# shellcheck disable=SC2046
install_msg "AUR packages" && yay \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/aur.txt") >/dev/null

# ==========================================
# Setup base packages
# ==========================================

setup_msg "grub" && ./setups/base/grub.sh
setup_msg "kde" && ./setups/base/kde.sh
setup_msg "konsole" && ./setups/base/konsole.sh
setup_msg "kscreenlocker" && ./setups/base/kscreenlocker.sh
setup_msg "night_color" && ./setups/base/night_color.sh
setup_msg "pacman" && ./setups/base/pacman.sh
setup_msg "sddm" && ./setups/base/sddm.sh

# ==========================================
# Setup official packages
# ==========================================

setup_msg "atuin" && ./setups/official/atuin.sh
setup_msg "bat" && ./setups/official/bat.sh
setup_msg "broot" && ./setups/official/broot.sh
setup_msg "btop" && ./setups/official/btop.sh
setup_msg "cups" && ./setups/official/cups.sh
setup_msg "direnv" && ./setups/official/direnv.sh
setup_msg "docker" && ./setups/official/docker.sh
setup_msg "eza" && ./setups/official/eza.sh
setup_msg "fzf" && ./setups/official/fzf.sh
setup_msg "kitty" && ./setups/official/kitty.sh
setup_msg "lazygit" && ./setups/official/lazygit.sh
setup_msg "libreoffice" && ./setups/official/libreoffice.sh
setup_msg "mkcert" && ./setups/official/mkcert.sh
setup_msg "neovim" && ./setups/official/neovim.sh
setup_msg "nvm" && ./setups/official/nvm.sh
setup_msg "obs_studio" && ./setups/official/obs_studio.sh
setup_msg "poetry" && ./setups/official/poetry.sh
setup_msg "pyenv" && ./setups/official/pyenv.sh
setup_msg "qBittorrent" && ./setups/official/qBittorrent.sh
setup_msg "reflector" && ./setups/official/reflector.sh
setup_msg "starship" && ./setups/official/starship.sh
setup_msg "superfile" && ./setups/official/superfile.sh
setup_msg "tmux" && ./setups/official/tmux.sh
setup_msg "vim" && ./setups/official/vim.sh
setup_msg "zoxide" && ./setups/official/zoxide.sh

# ==========================================
# Setup AUR packages
# ==========================================

setup_msg "bitwarden" && ./setups/aur/bitwarden.sh
setup_msg "blesh" && ./setups/aur/blesh.sh
setup_msg "papirus_folders" && ./setups/aur/papirus_folders.sh
setup_msg "proftpd" && ./setups/aur/proftpd.sh
setup_msg "tdrop" && ./setups/aur/tdrop.sh

# ==========================================
# Post install
# ==========================================

./scripts/update_bashrc.sh '[[ ${BLE_VERSION-} ]] && ble-attach'

setup_msg "bash" && ./setups/base/bash.sh

info_msg "Removing ${PASSWORDLESS_SUDO_FILE}..." && sudo rm -f "${PASSWORDLESS_SUDO_FILE}"
