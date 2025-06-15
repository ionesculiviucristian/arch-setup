#!/bin/bash
set -eu

update_app_theme() {
  local file="$1"
  local url="$2"
  local app="$3"
  local cmd="${4:-}"

  local tmp_file
  tmp_file="$(mktemp)"

  if ! wget -qO "${tmp_file}" "${url}"; then
    echo "Failed to download ${url}"
    rm -f "${tmp_file}"
    return 1
  fi

  if [ -f "${file}" ]; then
    local local_size remote_size
    local_size=$(stat -c%s "${file}")
    remote_size=$(stat -c%s "${tmp_file}")

    if [ "${local_size}" -ne "${remote_size}" ]; then
      echo "Updating Catppuccin for ${app}"
      mv "${tmp_file}" "${file}"
      eval "${cmd}"
    else
      rm "${tmp_file}"
    fi
  else
    echo "${file} not found"
  fi
}

cd "${HOME}/.repos/catppuccin-kde"
if ! git pull | grep -q "Already up to date."; then
  echo "Updating Catppuccin for KDE"
  printf "1\n4\n2\ny\ny" | ./install.sh
fi

cd "${HOME}/.repos/catppuccin-fzf"
if ! git pull | grep -q "Already up to date."; then
  echo "Updating Catppuccin for fzf"
fi

cd "${HOME}/.repos/catppuccin-grub"
if ! git pull | grep -q "Already up to date."; then
  echo "Updating Catppuccin for Grub"
  sudo cp -r "${HOME}/.repos/catppuccin-grub/src/catppuccin-mocha-grub-theme" "/usr/share/grub/themes/catppuccin-mocha-grub-theme"
fi

echo "Updating Catppuccin for Tmux"
cd "${HOME}/.config/tmux/plugins/catppuccin/tmux"
git fetch --tags
latest_tag=$(git tag --sort=-v:refname | head -n 1)
git checkout "${latest_tag}"

update_app_theme \
  "${HOME}/.config/atuin/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml \
  Atuin

update_app_theme \
  "${HOME}/.config/bat/themes/Catppuccin Mocha.tmTheme" \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme \
  Bat \
  bat cache --build

update_app_theme \
  "${HOME}/.config/btop/themes/catppuccin_mocha.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme \
  Btop

update_app_theme \
  "${HOME}/.config/kitty/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf \
  Kitty

update_app_theme \
  "${HOME}/.local/share/konsole/catppuccin-mocha.colorscheme" \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme \
  Konsole

update_app_theme \
  "${HOME}/.config/starship/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml \
  Starship \
  cat "${HOME}/.config/starship/config.toml" "${HOME}/.config/starship/themes/mocha.conf" > "${HOME}/.config/.starship.toml"

update_app_theme \
  "${HOME}/.config/superfile/theme/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml \
  Superfile

cd "${HOME}/.repos/multi-git-status"
if ! git pull | grep -q "Already up to date."; then
  echo "Updating multi-git-status"
  sudo make install
fi

echo "Updating nvm"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

echo "Updating poetry"
poetry self update

echo "Updating ble.sh"
echo "Update manually using ble-update"

echo "Updating Catppuccin for Lazygit"
echo "Update manually from https://github.com/catppuccin/lazygit"

echo "Updating Catppuccin for LibreOffice"
echo "Update manually from https://github.com/catppuccin/libreoffice"

echo "Updating Catppuccin for SDDM"
echo "Update manually from https://github.com/catppuccin/sddm"
