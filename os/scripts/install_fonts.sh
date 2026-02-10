#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

"${root_dir}/scripts/install_font.sh" \
  https://github.com/eigilnikolajsen/commit-mono/releases/download/v1.143/CommitMono-1.143.zip

"${root_dir}/scripts/install_font.sh" \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz

exit 0
