#!/bin/bash
set -eu

# @see [config](https://mpv.io/manual/stable/#configuration-files)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

mpv_config_dir="${HOME}/.config/mpv"
desktop_file="mpv.desktop"

install -D -m 644 \
  "${package_dir}/config/mpv.conf" \
  "${mpv_config_dir}/mpv.conf"

install -D -m 644 \
  "${package_dir}/config/input.conf" \
  "${mpv_config_dir}/input.conf"

mapfile -t mimetypes <"${package_dir}/config/mimetypes.txt"

xdg-mime default "${desktop_file}" "${mimetypes[@]}"

"${package_dir}/install-mpv-scripts.sh"

for link in fonts scripts/uosc; do
  if [ ! -L "${mpv_config_dir}/${link}" ]; then
    ln -s "/usr/share/mpv/${link}" "${mpv_config_dir}/${link}"
  fi
done

exit 0
