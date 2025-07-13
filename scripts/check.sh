#!/bin/bash
set -eu

green="\e[32m"
red="\e[31m"
reset="\e[0m"

check_package() {
  local pkg="$1"
  echo -n "Checking if package ${pkg} is installed... "
  if command -v "${pkg}" >/dev/null 2>&1; then
    echo -e "${green}YES${reset}"
  else
    echo -e "${red}NO${reset}"
  fi
}

check_dir() {
  local dir="$1"
  echo -n "Checking if directory ${dir} exists... "
  if [ -d "${dir}" ]; then
    echo -e "${green}YES${reset}"
  else
    echo -e "${red}NO${reset}"
  fi
}

check_file() {
  local file="$1"
  echo -n "Checking if file ${file} exists... "
  if [ -f "${file}" ]; then
    echo -e "${green}YES${reset}"
  else
    echo -e "${red}NO${reset}"
  fi
}

check_package yay
check_package mgitstatus
check_package npm
check_package pnpm
check_package poetry

check_dir "${HOME}/.bash_aliases.d"
check_dir "${HOME}/.local/share/fonts"
check_dir "${HOME}/.repos"
check_dir "${HOME}/Backups"
check_dir "${HOME}/Pictures/Wallpapers"
check_dir "${HOME}/Projects"
check_dir "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-cpu"
check_dir "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-battery"

check_file "${HOME}/.bashrc"
check_file "${HOME}/.local/share/konsole/Starship.profile"
check_file "/etc/sddm.conf.d/kde_settings.conf"
check_file "${HOME}/.config/bat/config"
check_file "${HOME}/.config/btop/btop.conf"
check_file "/etc/docker/daemon.json"
check_file "${HOME}/.config/kitty/kitty.conf"
check_file "${HOME}/.config/nvim/init.lua"
check_file "${HOME}/.config/.starship.toml"
check_file "${HOME}/.config/superfile/config.toml"
check_file "${HOME}/.local/share/applications/net.local.tdrop.desktop"
check_file "${HOME}/.tmux.conf"
check_file "${HOME}/.vimrc"

check_file "${HOME}/Pictures/Wallpapers/wp14259050-cyberpunk-3440x1440-wallpapers.png"
check_file "${HOME}/Pictures/Wallpapers/wp11361979-minimalist-3440x1440-wallpapers.png"

check_file "${HOME}/Pictures/Wallpapers/wp11361979-minimalist-3440x1440-wallpapers.png"
check_dir "/usr/share/grub/themes/catppuccin-mocha-grub-theme"
check_file "${HOME}/.local/share/konsole/catppuccin-mocha.colorscheme"
check_file "/usr/share/sddm/themes/catppuccin-mocha/backgrounds/wall.jpg"
check_file "${HOME}/.config/atuin/themes/catppuccin-mocha-mauve.toml"
check_file "${HOME}/.config/bat/themes/Catppuccin Mocha.tmTheme"
check_file "${HOME}/.config/btop/themes/catppuccin_mocha.theme"
check_file "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"
check_dir "${HOME}/.local/share/icons/catppuccin-mocha-mauve-cursors"
check_file "${HOME}/.config/kitty/themes/mocha.conf"
check_file "${HOME}/.config/lazygit/config.yml"
check_file "${HOME}/.config/libreoffice/4/user/registrymodifications.xcu"
check_file "${HOME}/.config/superfile/theme/catppuccin-mocha-mauve.toml"
check_dir "${HOME}/.config/tmux/plugins/catppuccin/tmux"
check_file "${HOME}/.vim/colors/catppuccin_mocha.vim"
