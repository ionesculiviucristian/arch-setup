#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/konsole

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/system/konsole.sh
source "./themes/base/system/konsole.sh"

install_konsole_theme

cp \
  "./configs/.local/share/konsole/${konsole_profile}" \
  "${konsole_dir}/${konsole_profile}"

kwriteconfig6 \
  --file "${HOME}/.config/konsolerc" \
  --group "Desktop Entry" \
  --key "DefaultProfile" \
  "${konsole_profile}"

exit 0
