#!/bin/bash
set -eu

# https://wiki.archlinux.org/title/CUPS

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

service_enable cups.service
service_start cups.service

exit 0
