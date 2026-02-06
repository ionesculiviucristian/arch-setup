#!/bin/bash
set -eu

# [bashrc] https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
# [Config] https://docs.atuin.sh/configuration/config/
# [Theme] https://github.com/catppuccin/atuin?tab=readme-ov-file#usage

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/official/atuin.sh
source "./themes/base/official/atuin.sh"

install_atuin_theme

cp \
  "./configs/.config/atuin/config.toml" \
  "${atuin_dir}/config.toml"

./scripts/update_bashrc.sh "atuin" <<'EOF'
# https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
eval "$(atuin init bash)"
EOF

exit 0
