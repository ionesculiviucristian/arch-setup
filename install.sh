#!/bin/bash
set -eu

exec 1>install_base.log
exec 2>errors_base.log

# shellcheck disable=SC1091
source "./scripts/installer.sh"

trap disable_passwordless_sudo EXIT

# ==========================================
# Pre install
# ==========================================

info "Starting installation..."

enable_passwordless_sudo

[ ! -f "./.env" ] && cp "./.env.example" "./.env"

info "Setup system..." && ./setups/base/system.sh

# ==========================================
# Install official packages
# ==========================================

info "Installing official packages..."
./installers/base/official_packages.sh

# ==========================================
# Setup system resources
# ==========================================

info "Setup system resources..."
info "  Creating directories" && ./setups/base/dirs.sh
info "  Installing fonts" && ./setups/base/fonts.sh
info "  Copying wallpapers" && ./setups/base/wallpapers.sh

# ==========================================
# Install external packages
# ==========================================

info "Installing external packages..."
info "  Yay" && ./installers/base/yay.sh

# ==========================================
# Install AUR packages
# ==========================================

info "Installing AUR packages..." && ./installers/base/aur_packages.sh

# ==========================================
# Setup base packages
# ==========================================

info "Setup base packages..."
info "  GRUB" && ./setups/base/system/grub.sh
info "  KDE" && ./setups/base/system/kde.sh
info "  Konsole" && ./setups/base/system/konsole.sh
info "  KScreenLocker" && ./setups/base/system/kscreenlocker.sh
info "  Night Color" && ./setups/base/system/night_color.sh
info "  pacman" && ./setups/base/system/pacman.sh
info "  SDDM" && ./setups/base/system/sddm.sh

# ==========================================
# Setup official packages
# ==========================================

info "Setup official packages..."
info "  Atuin" && ./setups/base/official/atuin.sh
info "  bat" && ./setups/base/official/bat.sh
info "  Bitwarden" && ./setups/base/official/bitwarden.sh
info "  broot" && ./setups/base/official/broot.sh
info "  Btop++" && ./setups/base/official/btop.sh
info "  direnv" && ./setups/base/official/direnv.sh
info "  eza" && ./setups/base/official/eza.sh
info "  fzf" && ./setups/base/official/fzf.sh
info "  kitty" && ./setups/base/official/kitty.sh
info "  lazygit" && ./setups/base/official/lazygit.sh
info "  LibreOffice" && ./setups/base/official/libreoffice.sh
info "  miniconda" && ./setups/base/official/miniconda.sh
info "  mkcert" && ./setups/base/official/mkcert.sh
info "  nvim" && ./setups/base/official/nvim.sh
info "  nvm" && ./setups/base/official/nvm.sh
info "  OpenPrinting CUPS" && ./setups/base/official/cups.sh
info "  poetry" && ./setups/base/official/poetry.sh
info "  pyenv" && ./setups/base/official/pyenv.sh
info "  qBittorrent" && ./setups/base/official/qBittorrent.sh
info "  reflector" && ./setups/base/official/reflector.sh
info "  rustup" && ./setups/base/official/rustup.sh
info "  Starship" && ./setups/base/official/starship.sh
info "  superfile" && ./setups/base/official/superfile.sh
info "  tmux" && ./setups/base/official/tmux.sh
info "  vim" && ./setups/base/official/vim.sh
info "  zoxide" && ./setups/base/official/zoxide.sh

# ==========================================
# Setup AUR packages
# ==========================================

info "Setup AUR packages..."
info "  ble.sh" && ./setups/base/aur/blesh.sh
info "  Papirus Folders" && ./setups/base/aur/papirus_folders.sh
info "  tdrop" && ./setups/base/aur/tdrop.sh

# ==========================================
# Post install
# ==========================================

info "Setup bash..." && ./setups/base/system/bash.sh

./scripts/update_bashrc.sh "blesh" << 'EOF'
[[ ${BLE_VERSION-} ]] && ble-attach
EOF

info "Installation finished"

info "After reboot run ${PWD}/setups/base/post_reboot.sh"

exit 0
