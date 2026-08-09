#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

day_temperature=$(env::get "NIGHT_COLOR_DAY_TEMPERATURE")
night_temperature=$(env::get "NIGHT_COLOR_NIGHT_TEMPERATURE")
latitude=$(env::get "NIGHT_COLOR_LATITUDE")
longitude=$(env::get "NIGHT_COLOR_LONGITUDE")

knighttimerc_file="${HOME}/.config/knighttimerc"
kwinrc_file="${HOME}/.config/kwinrc"

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
  "${day_temperature}"

kwriteconfig6 \
  --file "${kwinrc_file}" \
  --group "NightColor" \
  --key "Mode" \
  1

kwriteconfig6 \
  --file "${kwinrc_file}" \
  --group "NightColor" \
  --key "NightTemperature" \
  "${night_temperature}"

kwriteconfig6 \
  --file "${knighttimerc_file}" \
  --group "Location" \
  --key "Automatic" \
  --type "bool" \
  false

kwriteconfig6 \
  --file "${knighttimerc_file}" \
  --group "Location" \
  --key "Latitude" \
  "${latitude}"

kwriteconfig6 \
  --file "${knighttimerc_file}" \
  --group "Location" \
  --key "Longitude" \
  "${longitude}"

exit 0
