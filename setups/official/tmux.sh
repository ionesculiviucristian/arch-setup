#!/bin/bash
set -eu

mkdir -p "${HOME}/.config/tmux/plugins//tmux-plugins"

git clone -q https://github.com/tmux-plugins/tmux-cpu "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-cpu"
git clone -q https://github.com/tmux-plugins/tmux-battery "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-battery"

cp "./configs/.tmux.conf" "${HOME}/.tmux.conf"

tmux_plugins_dir="${HOME}/.config/tmux/plugins"

mkdir -p "${tmux_plugins_dir}"

rm -rf "${tmux_plugins_dir}/catppuccin"

git clone -q https://github.com/catppuccin/tmux.git "${tmux_plugins_dir}/catppuccin/tmux"

exit 0
