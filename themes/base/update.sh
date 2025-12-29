#!/bin/bash
set -eu

# shellcheck source=../../setups/base/_config.sh
source "./setups/base/_config.sh"

# shellcheck disable=SC1091
source "./scripts/installer.sh"

# ==========================================
# Update official package themes
# ==========================================

info "Updating official package themes..."

# shellcheck disable=SC1091
source "./themes/base/official/atuin.sh"
info "  atuin" && install_atuin_theme

# shellcheck disable=SC1091
source "./themes/base/official/bat.sh"
info "  bat" && install_bat_theme

# shellcheck disable=SC1091
source "./themes/base/official/broot.sh"
info "  broot" && install_broot_theme

# shellcheck disable=SC1091
source "./themes/base/official/btop.sh"
info "  btop" && install_btop_theme

# shellcheck disable=SC1091
source "./themes/base/official/eza.sh"
info "  eza" && install_eza_theme

# shellcheck disable=SC1091
source "./themes/base/official/fzf.sh"
info "  fzf" && install_fzf_theme

# shellcheck disable=SC1091
source "./themes/base/official/kitty.sh"
info "  kitty" && install_kitty_theme

# shellcheck disable=SC1091
source "./themes/base/official/lazygit.sh"
info "  lazygit" && install_lazygit_theme

# shellcheck disable=SC1091
source "./themes/base/official/libreoffice.sh"
info "  libreoffice" && install_libreoffice_theme

# shellcheck disable=SC1091
source "./themes/base/official/qBittorrent.sh"
info "  qBittorrent" && install_qbittorrent_theme

# shellcheck disable=SC1091
source "./themes/base/official/starship.sh"
info "  starship" && install_starship_theme

# shellcheck disable=SC1091
source "./themes/base/official/vim.sh"
info "  vim" && install_vim_theme

# ==========================================
# Update AUR package themes
# ==========================================

info "Updating AUR package themes..."

# shellcheck disable=SC1091
source "./themes/base/aur/superfile.sh"
info "  superfile" && install_superfile_theme

# ==========================================
# Update system package themes
# ==========================================

info "Updating system package themes..."

# shellcheck disable=SC1091
source "./themes/base/system/grub.sh"
info "  grub" && install_grub_theme

# shellcheck disable=SC1091
source "./themes/base/system/kde.sh"
info "  kde" && install_kde_theme

# shellcheck disable=SC1091
source "./themes/base/system/konsole.sh"
info "  konsole" && install_konsole_theme

# shellcheck disable=SC1091
source "./themes/base/system/sddm.sh"
info "  sddm" && install_sddm_theme

exit 0
