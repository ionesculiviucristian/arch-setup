#!/bin/bash
set -eu

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

kwriteconfig6 \
  --file "${kwinrc_file}" \
  --group "NightColor" \
  --key "Active" \
  --type "bool" \
  true

kwriteconfig6 \
  --file "${kwinrc_file}" \
  --group "NightColor" \
  --key "DayTemperature" \
  5700

kwriteconfig6 \
  --file "${kwinrc_file}" \
  --group "NightColor" \
  --key "LatitudeFixed" \
  45.65

kwriteconfig6 \
  --file "${kwinrc_file}" \
  --group "NightColor" \
  --key "LongitudeFixed" \
  25.63

kwriteconfig6 \
  --file "${kwinrc_file}" \
  --group "NightColor" \
  --key "Mode" \
  "Location"

kwriteconfig6 \
  --file "${kwinrc_file}" \
  --group "NightColor" \
  --key "NightTemperature" \
  3500

exit 0
