#!/bin/bash
set -eu

# https://github.com/direnv/direnv/blob/master/docs/hook.md#bash

./scripts/update_bashrc.sh 'eval "$(direnv hook bash)"'

exit 0
