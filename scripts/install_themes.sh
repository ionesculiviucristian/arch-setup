#!/bin/bash
set -eu

wallpapers_dir="${HOME}/Pictures/Wallpapers"

cp ../wallpapers/* "${wallpapers_dir}"

plasma-apply-wallpaperimage "${wallpapers_dir}/wp14259050-cyberpunk-3440x1440-wallpapers.png"

kwriteconfig6 \
  --file "${HOME}/.config/kscreenlockerrc" \
  --group "Greeter" --group "Wallpaper" --group "org.kde.image" --group "General" \
  --key "Image" "${wallpapers_dir}/wp11361979-minimalist-3440x1440-wallpapers.png"

kwriteconfig6 \
  --file "${HOME}/.config/kscreenlockerrc" \
  --group "Greeter" --group "Wallpaper" --group "org.kde.image" --group "General" \
  --key "PreviewImage" "${wallpapers_dir}/wp11361979-minimalist-3440x1440-wallpapers.png"

# ==========================================
# GRUB
# ==========================================

catppuccin_grub_dir="${HOME}/.repos/catppuccin-grub"
grub_themes_dir="/usr/share/grub/themes"

rm -rf "${catppuccin_grub_dir}"

git clone -q https://github.com/catppuccin/grub.git "${catppuccin_grub_dir}"

sudo cp -r "${catppuccin_grub_dir}/src/catppuccin-mocha-grub-theme" "${grub_themes_dir}/catppuccin-mocha-grub-theme"

if ! grep -q "catppuccin-mocha-grub-theme" "/boot/grub/grub.cfg"; then
  sudo sed -i 's|^#GRUB_THEME="/path/to/gfxtheme"|GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"|' "/etc/default/grub"

  sudo grub-mkconfig -o "/boot/grub/grub.cfg"
fi

# ==========================================
# Konsole
# ==========================================

konsole_dir="${HOME}/.local/share/konsole"

mkdir -p "${konsole_dir}"

wget -qO \
  "${konsole_dir}/catppuccin-mocha.colorscheme" \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme

# ==========================================
# SDDM 
# ==========================================

sddm_themes_dir="/usr/share/sddm/themes"

sudo pacman -Syu --needed --noconfirm \
  qt6-svg \
  qt6-declarative \
  qt5-quickcontrols2

wget -qO- https://github.com/catppuccin/sddm/releases/download/v1.1.0/catppuccin-mocha.zip | sudo bsdtar -xvf- -C "${sddm_themes_dir}"

sudo sed -i \
  -e 's/^CustomBackground="false"/CustomBackground="true"/' \
  "${sddm_themes_dir}/catppuccin-mocha/theme.conf"

sudo cp "${wallpapers_dir}/wp11361931-minimalist-3440x1440-wallpapers.png" "${sddm_themes_dir}/catppuccin-mocha/backgrounds/wall.jpg"

# ==========================================
# atuin
# ==========================================

atuin_dir="${HOME}/.config/atuin/themes"

mkdir -p "${atuin_dir}"

wget -qO \
  "${atuin_dir}/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 

# ==========================================
# bat
# ==========================================

bat_themes_dir="${HOME}/.config/bat/themes"

mkdir -p "${bat_themes_dir}"

wget -qO \
  "${bat_themes_dir}/Catppuccin Mocha.tmTheme" \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

bat cache --build

# ==========================================
# btop
# ==========================================

btop_themes_dir="${HOME}/.config/btop/themes"

mkdir -p "${btop_themes_dir}"

wget -qO \
  "${btop_themes_dir}/catppuccin_mocha.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme

# ==========================================
# fzf
# ==========================================

catppuccin_fzf_dir="${HOME}/.repos/catppuccin-fzf"

rm -rf "${catppuccin_fzf_dir}"

git clone https://github.com/catppuccin/fzf.git "${catppuccin_fzf_dir}"

./update_bashrc.sh 'source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"'

# ==========================================
# KDE
# ==========================================

catppuccin_kde_dir="${HOME}/.repos/catppuccin-fzf"
icons_dir="${HOME}/.local/share/icons"

rm -rf "${catppuccin_kde_dir}"

git clone --depth=1 https://github.com/catppuccin/kde "${catppuccin_kde_dir}"

(
  cd "${catppuccin_kde_dir}"
  printf "1\n4\n2\ny\ny" | ./install.sh

  rm -rf "${icons_dir}/Catppuccin-Mocha-Dark-Cursors"
  rm -rf "${icons_dir}/Catppuccin-Mocha-Mauve-Cursors"

  # Use newer Catppuccin cursors
  rm -rf "${icons_dir}/icons/catppuccin-mocha-mauve-cursors"
  wget -qO- https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-mauve-cursors.zip | bsdtar -xvf- -C "${icons_dir}"
  
  if [ ! -L "${HOME}/.icons" ]; then
    ln -s "${icons_dir}" "${HOME}/.icons"
  fi

  plasma-apply-cursortheme "catppuccin-mocha-mauve-cursors"
)

# ==========================================
# kitty
# ==========================================

kitty_themes_dir="${HOME}/.repos/catppuccin-fzf"

mkdir -p "${kitty_themes_dir}"

wget -qO \
  "${kitty_themes_dir}/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf

# ==========================================
# lazygit
# ==========================================

lazygit_dir="${HOME}/.repos/catppuccin-fzf"

mkdir -p "${lazygit_dir}"

wget -qO - https://raw.githubusercontent.com/catppuccin/lazygit/main/themes/mocha/mauve.yml \
  | yq eval-all --inplace 'select(fileIndex == 0) as $config | select(fileIndex == 1) as $res | $config | .gui.theme = ($res.theme) | .gui.authorColors = ($res.authorColors)' "${lazygit_dir}/config.yml" -

# ==========================================
# LibreOffice 
# ==========================================

libreoffice_user_dir="${HOME}/.config/libreoffice/4/user"

mkdir -p "${libreoffice_user_dir}/config"

wget -qO \
  "${libreoffice_user_dir}/config/catppuccin-mocha-mauve.soc" \
  https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/mocha/mauve/catppuccin-mocha-mauve.soc

libreoffice_theme_file=$(mktemp)

wget -qO \
  "${libreoffice_theme_file}" \
  https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/mocha/mauve/catppuccin-mocha-mauve.xcu

if [ ! -f "${libreoffice_user_dir}/registrymodifications.xcu" ]; then
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
    cat "${libreoffice_theme_file}"; echo
    echo '</oor:items>'
  } > "${libreoffice_user_dir}/registrymodifications.xcu"
else
  # shellcheck disable=SC2086
  sed -i \
    "s|<item oor:path=\"\/org.openoffice.Office.UI\/ColorScheme\/ColorSchemes\">.*<\/item>|$(cat ${libreoffice_theme_file})|" \
    "${libreoffice_user_dir}/registrymodifications.xcu"
fi


# ==========================================
# OBS Studio
# ==========================================
 
# https://github.com/catppuccin/obs

# ==========================================
# qbittorrent
# ==========================================
 
# https://github.com/catppuccin/qbittorrent

# ==========================================
# starship
# ==========================================

starship_dir="${HOME}/.config/starship"

mkdir -p "${starship_dir}/themes"

wget -qO \
  "${starship_dir}/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml

if [ -f "${starship_dir}/config.toml" ]; then
  cat \
    "${starship_dir}/config.toml" \
    "${starship_dir}/themes/mocha.conf" \
    > "${HOME}/.config/.starship.toml"
fi

# ==========================================
# superfile
# ==========================================

superfile_themes_dir="${HOME}/.config/superfile/theme"

mkdir -p "${superfile_themes_dir}"

wget -qO \
  "${superfile_themes_dir}/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml

# ==========================================
# Thunderbird  
# ==========================================

# https://github.com/catppuccin/thunderbird

# ==========================================
# tmux
# ==========================================

tmux_plugins_dir="${HOME}/.config/tmux/plugins"

mkdir -p "${tmux_plugins_dir}"

rm -rf "${tmux_plugins_dir}/catppuccin"

git clone https://github.com/catppuccin/tmux.git "${tmux_plugins_dir}/catppuccin/tmux"

# ==========================================
# vim 
# ==========================================

vim_themes_dir="${HOME}/.vim/colors"

mkdir -p "${vim_themes_dir}"

wget -qO \
  "${vim_themes_dir}/catppuccin_mocha.vim" \
  https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/catppuccin_mocha.vim

# ==========================================
# Papirus icons
# ==========================================

wget -qO- https://git.io/papirus-folders-install | sh

kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "Icons" --key "Theme" "Papirus-Dark"

papirus-folders -C violet --theme Papirus-Dark
