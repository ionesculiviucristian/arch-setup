#!/bin/bash
set -eu

# shellcheck source=../../setups/base/_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../scripts/installer.sh
source "./scripts/installer.sh"

# shellcheck source=./system/grub.sh
source "./themes/base/system/grub.sh"
# shellcheck source=./system/kde.sh
source "./themes/base/system/kde.sh"
# shellcheck source=./system/konsole.sh
source "./themes/base/system/konsole.sh"
# shellcheck source=./system/sddm.sh
source "./themes/base/system/sddm.sh"
# shellcheck source=./official/atuin.sh
source "./themes/base/official/atuin.sh"
# shellcheck source=./official/bat.sh
source "./themes/base/official/bat.sh"
# shellcheck source=./official/broot.sh
source "./themes/base/official/broot.sh"
# shellcheck source=./official/btop.sh
source "./themes/base/official/btop.sh"
# shellcheck source=./official/eza.sh
source "./themes/base/official/eza.sh"
# shellcheck source=./official/fzf.sh
source "./themes/base/official/fzf.sh"
# shellcheck source=./official/kitty.sh
source "./themes/base/official/kitty.sh"
# shellcheck source=./official/lazygit.sh
source "./themes/base/official/lazygit.sh"
# shellcheck source=./official/libreoffice.sh
source "./themes/base/official/libreoffice.sh"
# shellcheck source=./official/qBittorrent.sh
source "./themes/base/official/qBittorrent.sh"
# shellcheck source=./official/starship.sh
source "./themes/base/official/starship.sh"
# shellcheck source=./official/vim.sh
source "./themes/base/official/vim.sh"
# shellcheck source=./aur/superfile.sh
source "./themes/base/aur/superfile.sh"

# ==========================================
# Update system package themes
# ==========================================

info "Updating system package themes..."
info "  grub" && install_grub_theme
info "  kde" && install_kde_theme
info "  konsole" && install_konsole_theme
info "  sddm" && install_sddm_theme

# ==========================================
# Update official package themes
# ==========================================

info "Updating official package themes..."
info "  atuin" && install_atuin_theme
info "  bat" && install_bat_theme
info "  broot" && install_broot_theme
info "  btop" && install_btop_theme
info "  eza" && install_eza_theme
info "  fzf" && install_fzf_theme
info "  kitty" && install_kitty_theme
info "  lazygit" && install_lazygit_theme
info "  libreoffice" && install_libreoffice_theme
info "  qBittorrent" && install_qbittorrent_theme
info "  starship" && install_starship_theme
info "  vim" && install_vim_theme

# ==========================================
# Update AUR package themes
# ==========================================

info "Updating AUR package themes..."
info "  superfile" && install_superfile_theme

exit 0
