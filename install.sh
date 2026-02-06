#!/bin/bash
set -eu

exec 1>install_base.log
exec 2>install_errors_base.log

# shellcheck disable=SC1091
source "./scripts/installer.sh"

# Usage: ./install.sh [phase...]
# Phases: pre, packages, resources, external, aur, system-setups, official-setups, aur-setups, post
_phases=("${@}")
phase() { [[ ${#_phases[@]} -eq 0 ]] || [[ " ${_phases[*]} " == *" $1 "* ]]; }

trap 'enable_kernel_updates; disable_passwordless_sudo' EXIT

install_start=$SECONDS

info "Starting installation..."

enable_passwordless_sudo
disable_kernel_updates

[ ! -f "./.env" ] && cp "./.env.example" "./.env"

# ==========================================
# Pre install
# ==========================================

if phase pre; then
  timed "Setup system" ./setups/base/system.sh
fi

# ==========================================
# Install official packages
# ==========================================

if phase packages; then
  timed "Installing official packages" ./installers/base/official_packages.sh
fi

# ==========================================
# Setup system resources
# ==========================================

if phase resources; then
  _t=$SECONDS
  info "Setup system resources..."
  info "  Creating directories" && ./setups/base/dirs.sh
  info "  Installing fonts" && ./setups/base/fonts.sh
  info "  Copying wallpapers" && ./setups/base/wallpapers.sh
  info "Setup system resources done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Install external packages
# ==========================================

if phase external; then
  _t=$SECONDS
  info "Installing external packages..."
  info "  git-scope" && installers/base/external/git-scope.sh
  info "  Yay" && ./installers/base/external/yay.sh
  info "Installing external packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Install AUR packages
# ==========================================

if phase aur; then
  timed "Installing AUR packages" ./installers/base/aur_packages.sh
fi

# ==========================================
# Setup system packages
# ==========================================

if phase system-setups; then
  _t=$SECONDS
  info "Setup system packages..."
  info "  GRUB" && ./setups/base/system/grub.sh
  info "  KDE" && ./setups/base/system/kde.sh
  info "  Konsole" && ./setups/base/system/konsole.sh
  info "  KScreenLocker" && ./setups/base/system/kscreenlocker.sh
  info "  Night Color" && ./setups/base/system/night_color.sh
  info "  pacman" && ./setups/base/system/pacman.sh
  info "  SDDM" && ./setups/base/system/sddm.sh
  info "Setup system packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Setup official packages
# ==========================================

if phase official-setups; then
  _t=$SECONDS
  info "Setup official packages..."
  info "  Atuin" && ./setups/base/official/atuin.sh
  info "  bat" && ./setups/base/official/bat.sh
  info "  Bitwarden" && ./setups/base/official/bitwarden.sh
  info "  broot" && ./setups/base/official/broot.sh
  info "  Btop++" && ./setups/base/official/btop.sh
  info "  direnv" && ./setups/base/official/direnv.sh
  info "  eza" && ./setups/base/official/eza.sh
  info "  fzf" && ./setups/base/official/fzf.sh
  info "  Go" && ./setups/base/official/go.sh
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
  info "Setup official packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Setup AUR packages
# ==========================================

if phase aur-setups; then
  _t=$SECONDS
  info "Setup AUR packages..."
  info "  ble.sh" && ./setups/base/aur/blesh.sh
  info "  NordVPN" && ./setups/base/aur/nordvpn.sh
  info "  Papirus Folders" && ./setups/base/aur/papirus_folders.sh
  info "  tdrop" && ./setups/base/aur/tdrop.sh
  info "Setup AUR packages done in $(( SECONDS - _t ))s"
fi

# ==========================================
# Post install
# ==========================================

if phase post; then
  _t=$SECONDS
  info "Setup bash..."
  ./setups/base/system/bash.sh

  ./scripts/update_bashrc.sh "blesh" <<'EOF'
[[ ${BLE_VERSION-} ]] && ble-attach
EOF
  info "Setup bash done in $(( SECONDS - _t ))s"
fi

info "Installation finished in $(( SECONDS - install_start ))s"

info "After reboot run ${PWD}/setups/base/post_reboot.sh"

exit 0
