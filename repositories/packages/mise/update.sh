#!/bin/bash
set -eu

# @see [upgrade](https://mise.jdx.dev/cli/upgrade.html)

mise upgrade --yes

mise exec -- npm update --global

exit 0
