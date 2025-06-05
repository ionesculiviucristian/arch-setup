#!/bin/bash
set -eu

update_app_theme() {
  local file="$1"
  local url="$2"
  local app="$3"

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

    echo "Updating ${app} theme"

    if [ "${local_size}" -ne "${remote_size}" ]; then
      mv "${tmp_file}" "${file}"
      echo "Updated"
    else
      rm "${tmp_file}"
    fi
  else
    echo "${file} not found"
  fi
}

echo "Updating multi-git-status"
cd ~/.repos/multi-git-status
git pull
sudo make install

echo "Updating nvm"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

echo "Updating poetry"
poetry self update

update_app_theme \
  ~/.local/share/konsole/catppuccin-mocha.colorscheme \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme \
  konsole

update_app_theme \
  ~/.config/atuin/themes/catppuccin-mocha-mauve.toml \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml \
  atuin

update_app_theme \
  ~/.config/bat/themes/Catppuccin\ Mocha.tmTheme \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme \
  bat
bat cache --build

update_app_theme \
  ~/.config/btop/themes/catppuccin_mocha.theme \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme \
  btop

update_app_theme \
  ~/.config/kitty/themes/mocha.conf \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf \
  kitty

update_app_theme \
  ~/.config/starship/themes/mocha.conf \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml \
  starship
cat \
  ~/.config/starship/config.toml \
  ~/.config/starship/themes/mocha.conf \
  > ~/.config/.starship.toml

update_app_theme \
  ~/.config/superfile/theme/catppuccin-mocha-mauve.toml \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml \
  superfile

cd ~/.config/tmux/plugins/catppuccin/tmux
git fetch --tags
latest_tag=$(git tag --sort=-v:refname | head -n 1)
git checkout "${latest_tag}"

cd ~/.repos/catppuccin-kde
git pull
./install.sh 1 4 2

echo "Updating ble.sh"
echo "Update manually using ble-update"
