#!/bin/bash
set -eu

# [shell] https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc
# [config] https://github.com/akinomyoga/ble.sh/blob/master/blerc.template

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

bashrc_file="${HOME}/.bashrc"

cp "${root_dir}/repositories/packages/blesh-git/config/.blerc" "${HOME}/.blerc"

lines=$(
  cat <<'EOF'

[[ $- == *i* ]] && source -- "/usr/share/blesh/ble.sh" \
  --attach=none \
  --rcfile "${HOME}/.blerc"
EOF
)

if grep -F -A3 \
  "# https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#13-set-up-bashrc" \
  "${bashrc_file}" |
  grep -qF "${lines}"; then
  exit 0
fi

sed -i "/\[\[ \$- != \*i\* \]\] && return/r /dev/stdin" \
  "${bashrc_file}" <<<"${lines}"

exit 0
