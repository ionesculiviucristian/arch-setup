#!/bin/bash
set -eu

# [config] https://xyne.dev/projects/reflector/

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# shellcheck source=../../../.env
set -a && source "${root_dir}/.env" && set +a

export COUNTRY="${REFLECTOR_COUNTRY}"

envsubst <"${root_dir}/repositories/packages/reflector/config/reflector.conf.stub" |
  sudo tee "/etc/xdg/reflector/reflector.conf" >/dev/null

sudo systemctl enable --now reflector.timer

exit 0
