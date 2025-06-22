#!/bin/bash
set -eu

git clone https://github.com/fboender/multi-git-status.git "${HOME}/.repos/multi-git-status"

(
  cd "${HOME}/.repos/multi-git-status"
  sudo make install
)
