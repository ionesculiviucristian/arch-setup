#!/bin/bash
set -eu

# [Theme] https://github.com/catppuccin/kde

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

# shellcheck source=../../../themes/base/system/kde.sh
source "./themes/base/system/kde.sh"

install_kde_theme

exit 0
