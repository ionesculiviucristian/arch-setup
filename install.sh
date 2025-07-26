#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh"

# ==========================================
# Pre install
# ==========================================

echo > "./install.log"

PASSWORDLESS_SUDO_FILE="/etc/sudoers.d/$(whoami)"

_rmf_sudo "${PASSWORDLESS_SUDO_FILE}"

inform "Creating ${PASSWORDLESS_SUDO_FILE}" \
  && echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee "${PASSWORDLESS_SUDO_FILE}" 2>&1 | tee -a "./install.log" >/dev/null

_cp "./.env.example" "./.env"

inform_setup "power" && ./setups/power.sh

# ==========================================
# Install official packages
# ==========================================

# shellcheck disable=SC2046
inform_install "official packages" && sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/official.txt") 2>&1 2>&1 | tee -a "./install.log" >/dev/null

# ==========================================
# Setup system
# ==========================================

_cp "./configs/.bashrc" "${HOME}/.bashrc"

inform_setup "directories" && ./setups/dirs.sh
inform_setup "fonts" && ./setups/fonts.sh
inform_setup "wallpapers" && ./setups/wallpapers.sh

# ==========================================
# Install external packages
# ==========================================

inform_install "yay" && ./installers/yay.sh

# ==========================================
# Install AUR packages
# ==========================================

# shellcheck disable=SC2046
inform_install "AUR packages" && yay \
  -Syu \
  --needed \
  --noconfirm \
  $(<"./data/lists/aur.txt") 2>&1 | tee -a "./install.log" >/dev/null

# ==========================================
# Setup base packages
# ==========================================

inform_setup "GRUB" && ./setups/base/grub.sh
inform_setup "KDE" && ./setups/base/kde.sh
inform_setup "Konsole" && ./setups/base/konsole.sh
inform_setup "KScreenLocker" && ./setups/base/kscreenlocker.sh
inform_setup "Night Color" && ./setups/base/night_color.sh
inform_setup "pacman" && ./setups/base/pacman.sh
inform_setup "SDDM" && ./setups/base/sddm.sh

# ==========================================
# Setup official packages
# ==========================================

inform_setup "Atuin" && ./setups/official/atuin.sh
inform_setup "bat" && ./setups/official/bat.sh
inform_setup "broot" && ./setups/official/broot.sh
inform_setup "Btop++" && ./setups/official/btop.sh
inform_setup "OpenPrinting CUPS" && ./setups/official/cups.sh
inform_setup "direnv" && ./setups/official/direnv.sh
inform_setup "Docker" && ./setups/official/docker.sh
inform_setup "eza" && ./setups/official/eza.sh
inform_setup "fzf" && ./setups/official/fzf.sh
inform_setup "kitty" && ./setups/official/kitty.sh
inform_setup "lazygit" && ./setups/official/lazygit.sh
inform_setup "LibreOffice" && ./setups/official/libreoffice.sh
inform_setup "mkcert" && ./setups/official/mkcert.sh
inform_setup "neovim" && ./setups/official/neovim.sh
inform_setup "Node Version Manager" && ./setups/official/nvm.sh
inform_setup "OBS Studio" && ./setups/official/obs_studio.sh
inform_setup "Poetry" && ./setups/official/poetry.sh
inform_setup "pyenv" && ./setups/official/pyenv.sh
inform_setup "qBittorrent" && ./setups/official/qBittorrent.sh
inform_setup "reflector" && ./setups/official/reflector.sh
inform_setup "Starship" && ./setups/official/starship.sh
inform_setup "superfile" && ./setups/official/superfile.sh
inform_setup "tmux" && ./setups/official/tmux.sh
inform_setup "vim" && ./setups/official/vim.sh
inform_setup "zoxide" && ./setups/official/zoxide.sh

# ==========================================
# Setup AUR packages
# ==========================================

inform_setup "Bitwarden" && ./setups/aur/bitwarden.sh
inform_setup "ble.sh" && ./setups/aur/blesh.sh
inform_setup "Papirus Folders" && ./setups/aur/papirus_folders.sh
inform_setup "ProFTPD" && ./setups/aur/proftpd.sh
inform_setup "tdrop" && ./setups/aur/tdrop.sh

# ==========================================
# Post install
# ==========================================

./scripts/update_bashrc.sh '[[ ${BLE_VERSION-} ]] && ble-attach'

inform_setup "bash" && ./setups/base/bash.sh

inform "Removing ${PASSWORDLESS_SUDO_FILE}" && _rmf_sudo "${PASSWORDLESS_SUDO_FILE}"
