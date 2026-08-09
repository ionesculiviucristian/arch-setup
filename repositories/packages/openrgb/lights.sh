#!/bin/bash

# Sourced from ~/.bash_aliases.d: only define the shortcuts, before any `set` leaks into the shell
if [ "${BASH_SOURCE[0]}" != "$0" ]; then
  LIGHTS_BIN="$(readlink -f "${BASH_SOURCE[0]}")"
  export LIGHTS_BIN

  # @description Control the RGB lighting
  # @arg $1 string ACTION (on [colour], off, restore, status, colours, refresh; --persistent keeps on/off after login)
  function lights() {
    "${LIGHTS_BIN}" "$@"
  }

  # @description Turn the RGB lighting on
  alias lon='lights on'

  # @description Turn the RGB lighting off
  alias loff='lights off'

  complete -W "on off --persistent restore status colours refresh rainbow $(yq -r '.colours | keys | .[]' "${LIGHTS_CONFIG:-${HOME}/.config/lights/lights.yml}" 2>/dev/null)" lights

  return 0
fi

set -uo pipefail

config_dir="${HOME}/.config/lights"
config_file="${LIGHTS_CONFIG:-${config_dir}/lights.yml}"
cache_file="${HOME}/.cache/lights/openrgb-devices"
state_file="${HOME}/.local/state/lights/last"

config() {
  yq -r "$1" "${config_file}"
}

resolve_colour() {
  local want="${1,,}"
  want="${want#\#}"

  local named
  named=$(NAME="${want}" yq -r '.colours[env(NAME)] // ""' "${config_file}")

  if [ -n "${named}" ]; then
    echo "${named}"
  elif [[ "${want}" =~ ^[0-9a-f]{6}$ ]]; then
    echo "${want}"
  else
    echo "Unknown colour: '$1', use a hex triplet or one from 'lights colours'" >&2
    return 1
  fi
}

liquidctl_leds() {
  local action=$1 colour=${2:-}
  local device channel rainbow

  while IFS=$'\t' read -r channel device rainbow; do
    if ! liquidctl list 2>/dev/null | grep -qF "${device}"; then
      echo "   ${device}: not found, skipped"
      continue
    fi

    case "${action}" in
    off) liquidctl --match "${device}" set "${channel}" color off ;;
    rainbow) liquidctl --match "${device}" set "${channel}" color "${rainbow}" ;;
    *) liquidctl --match "${device}" set "${channel}" color fixed "${colour}" ;;
    esac && echo "   ${device}: ${action}${colour:+ #${colour}}"
  done < <(config '.liquidctl[] | [.channel, .device, .rainbow] | @tsv')
}

# --localconfig reads OpenRGB.json from the working directory; it hides the devices openrgb must not touch
orgb() {
  (cd "${config_dir}" && openrgb --localconfig "$@")
}

detect_openrgb_devices() {
  orgb --list-devices 2>/dev/null |
    awk -v types="^[[:space:]]*Type:[[:space:]]*($(config '.openrgb.types | join("|")'))" '
      /^[0-9]+:/ { idx = $1; sub(":", "", idx); next }
      $0 ~ types { print idx }'
}

# Detection takes a full openrgb launch, so the device indices are cached until openrgb or the configs change
openrgb_devices() {
  local key devices
  key=$(stat -c '%n %Y %s' "$(command -v openrgb)" "${config_dir}/OpenRGB.json" "${config_file}" | md5sum)

  if [ -r "${cache_file}" ] && [ "$(head -n 1 "${cache_file}")" = "${key}" ]; then
    tail -n +2 "${cache_file}"
    return
  fi

  devices=$(detect_openrgb_devices)
  [ -n "${devices}" ] || return 0

  mkdir -p "$(dirname "${cache_file}")"
  printf '%s\n%s\n' "${key}" "${devices}" >"${cache_file}"
  echo "${devices}"
}

openrgb_leds() {
  local colour=$1 mode attempt device
  local -a devices args
  mode=$(config '.openrgb.mode')

  for attempt in 1 2; do
    mapfile -t devices < <(openrgb_devices)

    if [ "${#devices[@]}" -eq 0 ]; then
      echo "   openrgb: no device detected, run 'lights status'"
      return
    fi

    args=()
    for device in "${devices[@]}"; do
      args+=(-d "${device}" -m "${mode}" -c "${colour}")
    done

    if orgb "${args[@]}" >/dev/null 2>&1; then
      echo "   openrgb: ${#devices[@]} device(s) #${colour}"
      return
    fi

    rm -f "${cache_file}"
    [ "${attempt}" = 1 ] && echo "   openrgb: write failed, re-detecting"
  done

  echo "   openrgb: FAILED"
}

save_state() {
  mkdir -p "$(dirname "${state_file}")"
  printf '%s\n' "$*" >"${state_file}"
}

restore_state() {
  [ -r "${state_file}" ] || return 0

  local -a args
  read -ra args <"${state_file}"
  "$0" "${args[@]}"
}

show_status() {
  echo "Config: ${config_file}"
  echo "Persistent state: $(cat "${state_file}" 2>/dev/null || echo none)"
  echo
  echo "SMBus adapter (RAM and motherboard):"
  if grep -qsi 'piix4\|smbus' /sys/class/i2c-dev/*/name; then
    echo "   present"
  else
    echo "   missing, add acpi_enforce_resources=lax to the kernel cmdline and reboot"
  fi
  echo
  echo "liquidctl devices:"
  liquidctl list 2>/dev/null | sed 's/^/   /'
  echo
  echo "openrgb devices:"
  orgb --list-devices 2>/dev/null | grep -E '^[0-9]+:' | sed 's/^/   /'
}

persistent=false
args=()
for arg in "$@"; do
  if [ "${arg}" = "--persistent" ]; then
    persistent=true
  else
    args+=("${arg}")
  fi
done
set -- "${args[@]}"

if [ "${persistent}" = "true" ]; then
  case "${1:-}" in
  on | off) save_state "$@" ;;
  esac
fi

case "${1:-}" in
on)
  colour=$(resolve_colour "$(config '.default_colour')") || exit 1
  if [ "${2:-}" = "rainbow" ]; then
    echo "Turning lights ON (rainbow)"
    liquidctl_leds rainbow
  else
    [ -n "${2:-}" ] && { colour=$(resolve_colour "$2") || exit 1; }
    echo "Turning lights ON (#${colour})"
    liquidctl_leds fixed "${colour}"
  fi
  openrgb_leds "${colour}"
  ;;
off)
  echo "Turning lights OFF"
  liquidctl_leds off
  openrgb_leds 000000
  ;;
colours | colors)
  config '.colours | to_entries[] | "   " + .key + " #" + .value'
  ;;
refresh)
  rm -f "${cache_file}"
  echo "Cache cleared, re-detecting"
  echo "   openrgb devices: $(openrgb_devices | paste -sd ' ')"
  ;;
restore)
  restore_state
  ;;
status)
  show_status
  ;;
*)
  echo "Usage: $(basename "$0") {on [colour|rainbow] | off} [--persistent] | restore | status | colours | refresh" >&2
  exit 1
  ;;
esac
