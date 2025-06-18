#!/bin/bash
set -eu

# ==========================================
# GRUB
# ==========================================

git clone https://github.com/catppuccin/grub.git "${HOME}/.repos/catppuccin-grub"

sudo cp -r "${HOME}/.repos/catppuccin-grub/src/catppuccin-mocha-grub-theme" "/usr/share/grub/themes/catppuccin-mocha-grub-theme"

sudo sed -i 's|^#GRUB_THEME="/path/to/gfxtheme"|GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"|' "/etc/default/grub"

sudo grub-mkconfig -o "/boot/grub/grub.cfg"

# ==========================================
# Konsole
# ==========================================

wget -qO \
  "${HOME}/.local/share/konsole/catppuccin-mocha.colorscheme" \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme

# ==========================================
# SDDM 
# ==========================================

sudo pacman -Syu --needed --noconfirm \
  qt6-svg \
  qt6-declarative \
  qt5-quickcontrols2

wget -qO- https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.zip | sudo bsdtar -xvf- -C "/usr/share/sddm/themes"

sudo sed -i \
  -e 's/^CustomBackground="false"/CustomBackground="true"/' \
  -e 's/^LoginBackground="false"/LoginBackground="true"/' \
  "/usr/share/sddm/themes/catppuccin-mocha/theme.conf"

sudo cp "wallpapers/UltrawideWallpapersDotNet-1128.jpeg" "/usr/share/sddm/themes/catppuccin-mocha/backgrounds/wall.jpg"

# ==========================================
# atuin
# ==========================================

mkdir -p "${HOME}/.config/atuin/themes"

wget -qO \
  "${HOME}/.config/atuin/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 

# ==========================================
# bat
# ==========================================

mkdir -p "${HOME}/.config/bat/themes"

wget -qO \
  "${HOME}/.config/bat/themes/Catppuccin Mocha.tmTheme" \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

bat cache --build

# ==========================================
# btop
# ==========================================

mkdir -p "${HOME}/.config/btop/themes"

wget -qO \
  "${HOME}/.config/btop/themes/catppuccin_mocha.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme

# ==========================================
# fzf
# ==========================================
 
git clone https://github.com/catppuccin/fzf.git "${HOME}/.repos/catppuccin-fzf"

echo 'source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"' >> "${HOME}/.bashrc"

# ==========================================
# KDE
# ==========================================

git clone --depth=1 https://github.com/catppuccin/kde "${HOME}/.repos/catppuccin-kde"

(
  cd "${HOME}/.repos/catppuccin-kde"
  printf "1\n4\n2\ny\ny" | ./install.sh

  # cd "$HOME/.icons"
  # curl -LOsS https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-mauve-cursors.zip
  # unzip "catppuccin-mocha-mauve-cursors.zip"
  # rm "catppuccin-mocha-mauve-cursors.zip"
)

# ==========================================
# kitty
# ==========================================

mkdir -p "${HOME}/.config/kitty/themes"

wget -qO \
  "${HOME}/.config/kitty/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf

# ==========================================
# lazygit
# ==========================================

mkdir "${HOME}/.config/lazygit"

wget -qO - https://raw.githubusercontent.com/catppuccin/lazygit/main/themes/mocha/mauve.yml \
  | yq eval '{"gui": .}' - > "${HOME}/.config/lazygit/config.yml"

# ==========================================
# LibreOffice 
# ==========================================

mkdir -p "${HOME}/.config/libreoffice/4/user/config"

wget -qO \
  "${HOME}/.config/libreoffice/4/user/config/catppuccin-mocha-mauve.soc" \
  https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/mocha/mauve/catppuccin-mocha-mauve.soc

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
  wget -qO - https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/mocha/mauve/catppuccin-mocha-mauve.xcu
  echo '</oor:items>'
} > "${HOME}/.config/libreoffice/4/user/registrymodifications.xcu"

# ==========================================
# OBS Studio
# ==========================================
 
# https://github.com/catppuccin/obs

# ==========================================
# Setup qbittorrent
# ==========================================
 
# https://github.com/catppuccin/qbittorrent

# ==========================================
# starship
# ==========================================

mkdir -p "${HOME}/.config/starship/themes"

wget -qO \
  "${HOME}/.config/starship/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml

# ==========================================
# Setup superfile
# ==========================================

mkdir -p "${HOME}/.config/superfile/theme"

wget -qO \
  "${HOME}/.config/superfile/theme/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml

# ==========================================
# Thunderbird  
# ==========================================

# https://github.com/catppuccin/thunderbird

# ==========================================
# tmux
# ==========================================

mkdir -p "${HOME}/.config/tmux/plugins/catppuccin"

git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "${HOME}/.config/tmux/plugins/catppuccin/tmux"

# ==========================================
# vim 
# ==========================================

mkdir -p "${HOME}/.vim/colors"

wget -qO \
  "${HOME}/.vim/colors/catppuccin_mocha.vim" \
  https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/catppuccin_mocha.vim

# ==========================================
# Papirus icons
# ==========================================

wget -qO- https://git.io/papirus-folders-install | sh

kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "Icons" --key "Theme" "Papirus-Dark"

papirus-folders -C violet --theme Papirus-Dark
