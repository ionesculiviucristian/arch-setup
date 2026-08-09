#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

install -D -m 755 \
  "${package_dir}/config/optiscale.py" \
  "${HOME}/.local/bin/optiscale"

exit 0
