#!/bin/bash
set -eu

# @see [config](https://mpv.io/manual/stable/#configuration-files)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

# shellcheck source=SCRIPTDIR/../../../lib/index.sh
source "${root_dir}/lib/index.sh"

mpv_config_file="${HOME}/.config/mpv/mpv.conf"
smplayer_config_file="${HOME}/.config/smplayer/smplayer.ini"

install -D -m 644 \
  "${package_dir}/config/mpv.conf" \
  "${mpv_config_file}"

if [ ! -f "${smplayer_config_file}" ]; then
  install -D -m 644 \
    "${package_dir}/config/smplayer.ini.stub" \
    "${smplayer_config_file}"
fi

file::replace_text \
  --range '/^\[advanced\]$/,/^\[/' \
  '^disable_player_config=.*' \
  'disable_player_config=true' \
  "${smplayer_config_file}"

file::replace_text \
  --range '/^\[advanced\]$/,/^\[/' \
  '^mplayer_additional_options=.*' \
  "mplayer_additional_options=\"--include=${mpv_config_file}\"" \
  "${smplayer_config_file}"

file::replace_text \
  --range '/^\[gui\]$/,/^\[/' \
  '^precise_seeking=.*' \
  'precise_seeking=true' \
  "${smplayer_config_file}"

file::replace_text \
  --range '/^\[gui\]$/,/^\[/' \
  '^seeking1=.*' \
  'seeking1=1' \
  "${smplayer_config_file}"

exit 0
