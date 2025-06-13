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

cd ~/.repos/catppuccin-kde
if ! git pull | grep -q "Already up to date."; then
  echo "Updating Catppuccin for KDE "
  ./install.sh 1 4 2
fi

update_app_theme \
  ~/.local/share/konsole/catppuccin-mocha.colorscheme \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme \
  Konsole

update_app_theme \
  ~/.config/atuin/themes/catppuccin-mocha-mauve.toml \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml \
  Atuin

update_app_theme \
  ~/.config/bat/themes/Catppuccin\ Mocha.tmTheme \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme \
  Bat \
  bat cache --build

update_app_theme \
  ~/.config/btop/themes/catppuccin_mocha.theme \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme \
  Btop

update_app_theme \
  ~/.config/kitty/themes/mocha.conf \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf \
  Kitty

update_app_theme \
  ~/.config/starship/themes/mocha.conf \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml \
  Starship \
  cat ~/.config/starship/config.toml ~/.config/starship/themes/mocha.conf > ~/.config/.starship.toml

update_app_theme \
  ~/.config/superfile/theme/catppuccin-mocha-mauve.toml \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml \
  Superfile

echo "Updating Catppuccin for Tmux"
cd ~/.config/tmux/plugins/catppuccin/tmux
git fetch --tags
latest_tag=$(git tag --sort=-v:refname | head -n 1)
git checkout "${latest_tag}"

cd ~/.repos/multi-git-status
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
