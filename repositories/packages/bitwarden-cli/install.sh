#!/bin/bash
set -eu

# @see [shell](https://bitwarden.com/help/cli/)

if mise exec -- npm ls --global --depth=0 @bitwarden/cli &>/dev/null; then
  exit 0
fi

mise exec -- npm install --global @bitwarden/cli

exit 0
