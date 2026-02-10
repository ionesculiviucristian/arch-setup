#!/bin/bash
set -eu

# [config] https://starship.rs/config/
# [shell] https://github.com/starship/starship?tab=readme-ov-file#step-2-set-up-your-shell-to-use-starship

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

starship_dir="${HOME}/.config/starship"

mkdir -p "${starship_dir}"

cp \
  "${root_dir}/repositories/packages/starship/config/config.toml" \
  "${starship_dir}/config.toml"

"${root_dir}/scripts/update_bashrc.sh" "starship" <<'EOF'
eval "$(starship init bash)"
EOF

exit 0
