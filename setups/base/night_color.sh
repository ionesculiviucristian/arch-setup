#!/bin/bash
set -eu

kwriteconfig6 \
  --file "${HOME}/.config/kwinrc" \
  --group "NightColor" \
  --key "Active" \
  --type "bool" \
  true

kwriteconfig6 \
  --file "${HOME}/.config/kwinrc" \
  --group "NightColor" \
  --key "DayTemperature" \
  5700

kwriteconfig6 \
  --file "${HOME}/.config/kwinrc" \
  --group "NightColor" \
  --key "LatitudeFixed" \
  45.65

kwriteconfig6 \
  --file "${HOME}/.config/kwinrc" \
  --group "NightColor" \
  --key "LongitudeFixed" \
  25.63

kwriteconfig6 \
  --file "${HOME}/.config/kwinrc" \
  --group "NightColor" \
  --key "Mode" \
  "Location"

kwriteconfig6 \
  --file "${HOME}/.config/kwinrc" \
  --group "NightColor" \
  --key "NightTemperature" \
  3500

exit 0
