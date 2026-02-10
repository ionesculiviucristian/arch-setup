#!/bin/bash
set -eu

# [config] https://docs.atuin.sh/cli/configuration/config/
# [shell] https://docs.atuin.sh/cli/guide/installation/#__tabbed_2_2

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

atuin_dir="${HOME}/.config/atuin"

mkdir -p "${atuin_dir}"

cp \
  "${root_dir}/repositories/packages/atuin/config/config.toml" \
  "${atuin_dir}/config.toml"

"${root_dir}/scripts/update_bashrc.sh" "atuin" <<'EOF'
eval "$(atuin init bash)"
EOF

exit 0
