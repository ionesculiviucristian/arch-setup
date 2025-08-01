#!/bin/bash
set -eu

# [bashrc] https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
# [Config] https://github.com/akinomyoga/ble.sh/blob/master/blerc.template

basrc_file="${HOME}/.bashrc"

cp "./configs/.blerc" "${HOME}/.blerc"

lines=$(cat <<'EOF'

# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
[[ $- == *i* ]] && source -- "/usr/share/blesh/ble.sh" \
  --attach=none \
  --rcfile "${HOME}/.blerc"
EOF
)

if grep -Pzoq "$(printf '%s' "${lines}")" "${basrc_file}"; then
  exit 0
fi

sed -i "/\[\[ \$- != \*i\* \]\] && return/r /dev/stdin" \
  "${basrc_file}" <<<"${lines}"

exit 0
