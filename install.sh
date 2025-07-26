#!/bin/bash
set -eu

# shellcheck disable=SC1091
source "./scripts/helpers.sh"

# ==========================================
# Pre install
# ==========================================

PASSWORDLESS_SUDO_FILE="/etc/sudoers.d/$(whoami)"

sudo rm -f "${PASSWORDLESS_SUDO_FILE}"

info_msg "Creating ${PASSWORDLESS_SUDO_FILE}" \
  && echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee "${PASSWORDLESS_SUDO_FILE}" >/dev/null

copy "./.env.example" "./.env"

setup_msg "power" && ./setups/power.sh

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

copy "./configs/.bashrc" "${HOME}/.bashrc"

setup_msg "directories" && ./setups/dirs.sh
setup_msg "fonts" && ./setups/fonts.sh
setup_msg "wallpapers" && ./setups/wallpapers.sh

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

setup_msg "GRUB" && ./setups/base/grub.sh
setup_msg "KDE" && ./setups/base/kde.sh
setup_msg "Konsole" && ./setups/base/konsole.sh
setup_msg "KScreenLocker" && ./setups/base/kscreenlocker.sh
setup_msg "Night Color" && ./setups/base/night_color.sh
setup_msg "pacman" && ./setups/base/pacman.sh
setup_msg "SDDM" && ./setups/base/sddm.sh

# ==========================================
# Setup official packages
# ==========================================

setup_msg "Atuin" && ./setups/official/atuin.sh
setup_msg "bat" && ./setups/official/bat.sh
setup_msg "broot" && ./setups/official/broot.sh
setup_msg "Btop++" && ./setups/official/btop.sh
setup_msg "OpenPrinting CUPS" && ./setups/official/cups.sh
setup_msg "direnv" && ./setups/official/direnv.sh
setup_msg "Docker" && ./setups/official/docker.sh
setup_msg "eza" && ./setups/official/eza.sh
setup_msg "fzf" && ./setups/official/fzf.sh
setup_msg "kitty" && ./setups/official/kitty.sh
setup_msg "lazygit" && ./setups/official/lazygit.sh
setup_msg "LibreOffice" && ./setups/official/libreoffice.sh
setup_msg "mkcert" && ./setups/official/mkcert.sh
setup_msg "neovim" && ./setups/official/neovim.sh
setup_msg "Node Version Manager" && ./setups/official/nvm.sh
setup_msg "OBS Studio" && ./setups/official/obs_studio.sh
setup_msg "Poetry" && ./setups/official/poetry.sh
setup_msg "pyenv" && ./setups/official/pyenv.sh
setup_msg "qBittorrent" && ./setups/official/qBittorrent.sh
setup_msg "reflector" && ./setups/official/reflector.sh
setup_msg "Starship" && ./setups/official/starship.sh
setup_msg "superfile" && ./setups/official/superfile.sh
setup_msg "tmux" && ./setups/official/tmux.sh
setup_msg "vim" && ./setups/official/vim.sh
setup_msg "zoxide" && ./setups/official/zoxide.sh

# ==========================================
# Setup AUR packages
# ==========================================

setup_msg "Bitwarden" && ./setups/aur/bitwarden.sh
setup_msg "ble.sh" && ./setups/aur/blesh.sh
setup_msg "Papirus Folders" && ./setups/aur/papirus_folders.sh
setup_msg "ProFTPD" && ./setups/aur/proftpd.sh
setup_msg "tdrop" && ./setups/aur/tdrop.sh

# ==========================================
# Post install
# ==========================================

./scripts/update_bashrc.sh '[[ ${BLE_VERSION-} ]] && ble-attach'

setup_msg "bash" && ./setups/base/bash.sh

info_msg "Removing ${PASSWORDLESS_SUDO_FILE}" && sudo rm -f "${PASSWORDLESS_SUDO_FILE}"
