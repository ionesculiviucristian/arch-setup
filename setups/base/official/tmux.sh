#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/tmux

tmux_plugins_dir="${HOME}/.config/tmux/plugins"

mkdir -p "${tmux_plugins_dir}/tmux-plugins"

rm -rf "${tmux_plugins_dir}/tmux-plugins/tmux-cpu"
rm -rf "${tmux_plugins_dir}/tmux-plugins/tmux-battery"
rm -rf "${tmux_plugins_dir}/catppuccin"

git clone -q \
  https://github.com/tmux-plugins/tmux-cpu \
  "${tmux_plugins_dir}/tmux-plugins/tmux-cpu"

git clone -q \
  https://github.com/tmux-plugins/tmux-battery \
  "${tmux_plugins_dir}/tmux-plugins/tmux-battery"

git clone -q \
  https://github.com/catppuccin/tmux.git \
  "${tmux_plugins_dir}/catppuccin/tmux"

cp "./configs/.tmux.conf" "${HOME}/.tmux.conf"

exit 0
