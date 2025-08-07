#!/bin/bash
set -eu

# ==========================================
# Pre install
# ==========================================

PASSWORDLESS_SUDO_FILE="/etc/sudoers.d/$(whoami)"

sudo rm -f "${PASSWORDLESS_SUDO_FILE}"

echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | \
  sudo tee "${PASSWORDLESS_SUDO_FILE}" >/dev/null

if [ ! -f "./.env" ]; then
  cp "./.env.example" "./.env"
fi

./setups/base/system.sh

# ==========================================
# Install official packages
# ==========================================

./installers/base/official_packages.sh

# ==========================================
# Setup system
# ==========================================

./setups/base/dirs.sh
./setups/base/fonts.sh
./setups/base/wallpapers.sh

# ==========================================
# Install external packages
# ==========================================

./installers/base/yay.sh

# ==========================================
# Install AUR packages
# ==========================================

./installers/base/aur_packages.sh

# ==========================================
# Setup base packages
# ==========================================

./setups/base/system/grub.sh
./setups/base/system/kde.sh
./setups/base/system/konsole.sh
./setups/base/system/kscreenlocker.sh
./setups/base/system/night_color.sh
./setups/base/system/pacman.sh
./setups/base/system/sddm.sh

# ==========================================
# Setup official packages
# ==========================================

./setups/base/official/adguardhome.sh
./setups/base/official/atuin.sh
./setups/base/official/bat.sh
./setups/base/official/broot.sh
./setups/base/official/btop.sh
./setups/base/official/cups.sh
./setups/base/official/direnv.sh
./setups/base/official/dnsmasq.sh
./setups/base/official/eza.sh
./setups/base/official/fzf.sh
./setups/base/official/kitty.sh
./setups/base/official/lazygit.sh
./setups/base/official/libreoffice.sh
./setups/base/official/mkcert.sh
./setups/base/official/neovim.sh
./setups/base/official/nvm.sh
./setups/base/official/poetry.sh
./setups/base/official/pyenv.sh
./setups/base/official/qBittorrent.sh
./setups/base/official/reflector.sh
./setups/base/official/starship.sh
./setups/base/official/superfile.sh
./setups/base/official/tmux.sh
./setups/base/official/vim.sh
./setups/base/official/zoxide.sh

# ==========================================
# Setup AUR packages
# ==========================================

./setups/base/aur/bitwarden.sh
./setups/base/aur/blesh.sh
./setups/base/aur/papirus_folders.sh
./setups/base/aur/tdrop.sh

# ==========================================
# Post install
# ==========================================

./setups/base/system/bash.sh

./scripts/update_bashrc.sh << 'EOF'
[[ ${BLE_VERSION-} ]] && ble-attach
EOF

sudo rm -f "${PASSWORDLESS_SUDO_FILE}"

echo "After reboot run ${PWD}/setups/base/post_reboot.sh"

exit 0
