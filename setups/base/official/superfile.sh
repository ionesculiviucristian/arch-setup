#!/bin/bash
set -eu

# [Config] https://superfile.netlify.app/configure/superfile-config/
# [Theme] https://github.com/catppuccin/superfile

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/aur/superfile.sh
source "./themes/base/aur/superfile.sh"

install_superfile_theme

cp \
  "./configs/.config/superfile/config.toml" \
  "${superfile_dir}/config.toml"

exit 0
