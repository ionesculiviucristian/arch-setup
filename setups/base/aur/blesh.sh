#!/bin/bash
set -eu

# [bashrc] https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
# [Config] https://github.com/akinomyoga/ble.sh/blob/master/blerc.template

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

cp "./configs/.blerc" "${HOME}/.blerc"

lines=$(cat <<'EOF'

# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
[[ $- == *i* ]] && source -- "/usr/share/blesh/ble.sh" \
  --attach=none \
  --rcfile "${HOME}/.blerc"
EOF
)

if grep -F -A3 \
  "# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc" \
  "${bashrc_file}" | \
  grep -qF "${lines}"; then
    exit 0
fi

sed -i "/\[\[ \$- != \*i\* \]\] && return/r /dev/stdin" \
  "${bashrc_file}" <<<"${lines}"

exit 0
