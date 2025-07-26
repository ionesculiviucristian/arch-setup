#!/bin/bash
set -eu

# https://github.com/catppuccin/tmux

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

tmux_plugins_dir="${HOME}/.config/tmux/plugins"

_mkdir "${tmux_plugins_dir}/tmux-plugins"

_rmdir "${tmux_plugins_dir}/tmux-plugins/tmux-cpu"
_rmdir "${tmux_plugins_dir}/tmux-plugins/tmux-battery"

git_clone https://github.com/tmux-plugins/tmux-cpu "${tmux_plugins_dir}/tmux-plugins/tmux-cpu"
git_clone https://github.com/tmux-plugins/tmux-battery "${tmux_plugins_dir}/tmux-plugins/tmux-battery"

_rmdir "${tmux_plugins_dir}/catppuccin"

git_clone https://github.com/catppuccin/tmux.git "${tmux_plugins_dir}/catppuccin/tmux"

_cp \
  "./configs/.tmux.conf" \
  "${HOME}/.tmux.conf"

exit 0
