#!/bin/bash
#
# lights - turn the machine's RGB lighting on or off, on demand.
#
#   lights off              everything dark
#   lights on               everything one colour (DEFAULT_ON_COLOUR below)
#   lights on <colour>      everything that colour: a name or a hex triplet
#                           e.g. lights on red / lights on 00ff88 / on '#0f8'
#   lights on rainbow       case strip cycles the spectrum; RAM and board take
#                           the default colour, being static-only devices
#   lights status           what is detected and what is controllable
#   lights colours          list the colour names it knows
#   lights refresh          forget the cached device list and re-detect
#                           (needed after changing or adding RGB hardware)
#
# Deliberately NOT persistent: no systemd unit, no autostart. After a reboot
# the hardware returns to its firmware defaults. Run the command when you
# want a change, that is all.
#
# ---------------------------------------------------------------------------
# SHORTCUTS
#
# This file does double duty. Executed, it does the work. Sourced, it only
# defines the shell shortcuts and returns:
#
#     lights on | off | status      (tab-completes, colour names included)
#     lon                           = lights on
#     loff                          = lights off
#
# To get them in every shell, symlink this file into the aliases drop-in
# directory that ~/.bash_aliases already sources - no existing file is
# touched, nothing is edited:
#
#     ln -s ~/Projects/arch-setup/scripts/lights.sh ~/.bash_aliases.d/lights.sh
#
# ---------------------------------------------------------------------------
# WHAT IT COVERS, AND WHY TWO TOOLS
#
#   case RGB strip     USB HID   -> liquidctl   (ships udev rules, no root)
#   Corsair RGB DRAM   SMBus     -> openrgb     (needs root: /dev/i2c-* is
#   motherboard LEDs   SMBus     -> openrgb      owned by root:i2c)
#
# The case is on liquidctl rather than openrgb on purpose. The NZXT Smart
# Device V1 is a single controller that drives BOTH the RGB strip AND the
# three case fan channels, so it is also what nzxt-fans.service talks to.
# One tool per device keeps this script from fighting the fan service.
#
# ---------------------------------------------------------------------------
# PREREQUISITE FOR THE RAM AND MOTHERBOARD (one-time, already done here)
#
# Both hang off the motherboard SMBus, which the kernel exposes through
# i2c_piix4. By default that driver loads but registers ZERO buses: ACPI has
# claimed the SMBus I/O range and the driver silently backs off. Until that
# is lifted, no user-space tool can reach either device.
#
# The fix is a kernel parameter, in GRUB_CMDLINE_LINUX_DEFAULT:
#
#     acpi_enforce_resources=lax
#
#     sudo grub-mkconfig -o /boot/grub/grub.cfg && reboot
#
# Same family of problem as the it87 sensor chip on this board needing
# ignore_resource_conflict=1. After the reboot an "SMBus PIIX4 adapter" bus
# appears and openrgb can see the DIMMs and the board. 'lights status'
# reports whether it is in place.
#
# ---------------------------------------------------------------------------
# WHY OPENRGB IS FENCED IN  (read before "simplifying" the orgb() wrapper)
#
# openrgb's detection does not merely LOOK at devices, it INITIALISES every
# one it recognises. Run unconstrained on this machine it:
#
#   * grabs the NZXT hub and resets the case fan duty cycle - the fans audibly
#     spin up, and the profile set by nzxt-fans.service is lost
#   * grabs the Logitech receivers and knocks wireless mice offline (the G703
#     went dead and needed the receiver re-detected)
#
# Merely listing devices is enough to cause it, so it is not avoidable by
# being careful about which device gets written to. The fix is to stop
# openrgb from ever seeing them: scripts/openrgb/OpenRGB.json disables all
# NZXT and Logitech detectors, and every openrgb call here goes through
# orgb(), which loads that config with --localconfig. The user's global
# openrgb config is left alone.
#
# NOTE: openrgb REWRITES that file on exit, expanding it to its full detector
# list. That is expected and harmless - the disabled entries are preserved.

# ====== WHAT A BARE "lights on" MEANS =======================================
DEFAULT_ON_COLOUR="ff8800" # a name from the table below, or a hex triplet

# The openrgb mode used for the RAM and the motherboard. It must be a mode
# those devices actually list ('lights status' shows them). Neither offers
# "Static" - both sit in "Direct", which is the per-LED mode - so asking for
# static leaves zones untouched, which is how the rear case LED stayed lit.
SMBUS_MODE="direct"
# ============================================================================

# --- sourced? define the shortcuts and stop -------------------------------
#
# This runs before the 'set' below on purpose: 'set -u' leaking into an
# interactive shell would make every unset variable a fatal error.

if [ "${BASH_SOURCE[0]}" != "$0" ]; then
  LIGHTS_BIN="$(readlink -f "${BASH_SOURCE[0]}")"
  export LIGHTS_BIN

  # @info Control the RGB lighting (case strip, RAM, motherboard)
  # @group lights
  # @param <on [colour]|off|status|colours|refresh>
  function lights() {
    "${LIGHTS_BIN}" "$@"
  }

  # @info Turn the RGB lighting on
  # @group lights
  alias lon='lights on'

  # @info Turn the RGB lighting off
  # @group lights
  alias loff='lights off'

  complete -W "on off status colours refresh rainbow white red green blue cyan magenta yellow orange purple pink lime teal amber warm ice deeppink" lights

  return 0
fi

set -uo pipefail

have() { command -v "$1" >/dev/null 2>&1; }

# --- colour ---------------------------------------------------------------
#
# One colour drives both tools, so it is resolved once, up front, to a bare
# 6-digit hex triplet: liquidctl and openrgb both accept that form.

declare -A COLOURS=(
  [white]=ffffff [red]=ff0000 [green]=00ff00 [blue]=0000ff
  [cyan]=00ffff [magenta]=ff00ff [yellow]=ffff00 [orange]=ff8800
  [purple]=8800ff [pink]=ff40a0 [lime]=88ff00 [teal]=00ff88
  [amber]=ffbb00 [warm]=ff9944 [ice]=aaddff [deeppink]=ff0080
)

list_colours() {
  local name
  echo "Known colour names:"
  for name in $(printf '%s\n' "${!COLOURS[@]}" | sort); do
    printf '   %-10s #%s\n' "${name}" "${COLOURS[${name}]}"
  done
  echo
  echo "Any 6-digit hex triplet also works: lights on 3a7bd5   (# is optional)"
}

# Prints the hex triplet, or fails with a usable message.
resolve_colour() {
  local want="${1,,}"
  want="${want#\#}"

  if [ -n "${COLOURS[${want}]:-}" ]; then
    echo "${COLOURS[${want}]}"
  elif [[ "${want}" =~ ^[0-9a-f]{6}$ ]]; then
    echo "${want}"
  elif [[ "${want}" =~ ^([0-9a-f])([0-9a-f])([0-9a-f])$ ]]; then
    # CSS-style shorthand: 0f8 -> 00ff88
    echo "${BASH_REMATCH[1]}${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}${BASH_REMATCH[3]}"
  else
    echo "Unknown colour: '$1'" >&2
    echo "Use a hex triplet (ff8800) or one of: ${!COLOURS[*]}" >&2
    return 1
  fi
}

# --- NZXT case strip ------------------------------------------------------

# case_leds <mode> [hex]   mode 'off' needs no colour
case_leds() {
  local mode="$1" colour="${2:-}"

  have liquidctl || {
    echo "   case: liquidctl not installed - skipped"
    return
  }
  lsusb 2>/dev/null | grep -q '1e71:1714' || {
    echo "   case: NZXT hub not on USB - skipped"
    return
  }

  if [ "${mode}" = "off" ]; then
    liquidctl set led color off 2>/dev/null && echo "   case: off"
  elif liquidctl set led color "${mode}" "${colour}" 2>/dev/null; then
    echo "   case: ${mode} #${colour}"
  else
    # Multi-colour modes (spectrum-wave and friends) take no colour argument.
    liquidctl set led color "${mode}" 2>/dev/null && echo "   case: ${mode}"
  fi
}

# --- SMBus devices: RAM + motherboard --------------------------------------

OPENRGB_CONFIG_DIR="$(dirname "$(readlink -f "$0")")/openrgb"

# --localconfig reads OpenRGB.json from the working directory, so run from there.
orgb() {
  (cd "${OPENRGB_CONFIG_DIR}" && sudo openrgb --localconfig "$@")
}

# Indices of the devices we are willing to touch. Parsed rather than hardcoded
# so a different RAM kit, or a different number of sticks, still works.
# The type whitelist is a second safety net behind the detector blocklist:
# even if a detector slipped through, only RAM and the board are written to.
detect_indices() {
  orgb --list-devices 2>/dev/null |
    awk '/^[0-9]+:/ { idx = $1; sub(":", "", idx); next }
         /^[[:space:]]*Type:[[:space:]]*(DRAM|Motherboard)/ { print idx }'
}

# --- device cache ---------------------------------------------------------
#
# Detection costs a full openrgb launch, about 4s. Without a cache every
# on/off pays it twice: once to find the devices, once to write to them.
# The indices are stable between runs, so they are remembered.
#
# The fingerprint covers the openrgb binary and the detector blocklist:
# either changing can change what gets detected, so the cache must not
# outlive them. It deliberately does NOT cover the hardware - detecting a
# new RGB device on every run is exactly the cost being avoided here. After
# adding or swapping RGB hardware, run 'lights refresh'.

CACHE_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/lights/smbus-devices"

cache_fingerprint() {
  stat -c '%n %Y %s' \
    "$(command -v openrgb)" \
    "${OPENRGB_CONFIG_DIR}/OpenRGB.json" 2>/dev/null |
    md5sum | cut -d' ' -f1
}

# Prints the cached indices, or fails if there is no usable cache.
cache_read() {
  local stored_fp stored_idx
  [ -r "${CACHE_FILE}" ] || return 1
  {
    read -r stored_fp
    read -r stored_idx
  } <"${CACHE_FILE}" || return 1
  [ -n "${stored_idx}" ] || return 1
  [ "${stored_fp}" = "$(cache_fingerprint)" ] || return 1
  echo "${stored_idx}"
}

cache_write() {
  mkdir -p "$(dirname "${CACHE_FILE}")" || return 0
  {
    cache_fingerprint
    echo "$*"
  } >"${CACHE_FILE}"
}

# One openrgb launch for ALL devices, not one per device: each launch pays a
# full detection pass, so looping would multiply the cost for no reason. The
# CLI accepts repeated -d/-m/-c groups in a single command.
apply_smbus() {
  local colour="$1"
  shift
  local -a args=()
  local i

  for i in "$@"; do
    args+=(-d "${i}" -m "${SMBUS_MODE}" -c "${colour}")
  done

  orgb "${args[@]}" >/dev/null 2>&1
}

# smbus_leds <hex>   000000 is how these devices are turned off
smbus_leds() {
  local colour="$1"
  local -a idx
  local cached

  have openrgb || {
    echo "   smbus: openrgb not installed - skipped"
    return
  }

  if cached="$(cache_read)"; then
    read -ra idx <<<"${cached}"
  else
    mapfile -t idx < <(detect_indices)
    [ "${#idx[@]}" -gt 0 ] && cache_write "${idx[@]}"
  fi

  if [ "${#idx[@]}" -eq 0 ]; then
    echo "   smbus: no RAM or motherboard device detected - skipped"
    echo "          run 'lights status' to see why"
    return
  fi

  if apply_smbus "${colour}" "${idx[@]}"; then
    echo "   smbus: ${#idx[@]} device(s) -> #${colour}  [${idx[*]}]"
    return
  fi

  # A cached index can go stale if RGB hardware was added or removed. Rather
  # than leave the user with a dead command, re-detect once and retry.
  echo "   smbus: write failed - re-detecting..."
  mapfile -t idx < <(detect_indices)
  if [ "${#idx[@]}" -gt 0 ] && apply_smbus "${colour}" "${idx[@]}"; then
    cache_write "${idx[@]}"
    echo "   smbus: ${#idx[@]} device(s) -> #${colour}  [${idx[*]}]"
  else
    echo "   smbus: FAILED"
  fi
}

# --- status ---------------------------------------------------------------

show_status() {
  local cached

  echo "liquidctl : $(have liquidctl && echo installed || echo 'not installed')"
  echo "openrgb   : $(have openrgb && echo installed || echo 'not installed')"
  echo
  echo "SMBus adapter (required for the RAM and the motherboard):"
  if grep -qsi 'piix4\|smbus' /sys/class/i2c-dev/*/name; then
    echo "   present - RAM and motherboard should be controllable"
  else
    echo "   MISSING - i2c_piix4 registered no bus, so both are unreachable."
    echo "   ACPI has claimed the SMBus I/O range and the driver backs off."
    echo "   Fix: acpi_enforce_resources=lax on the kernel cmdline, then reboot."
  fi
  echo
  # Checked via the drop-in, not via 'type': this runs in a subprocess, where
  # the parent shell's function and aliases are not visible either way.
  echo "Shell shortcuts (lights / lon / loff):"
  if [ -e "${HOME}/.bash_aliases.d/lights.sh" ]; then
    echo "   installed - loaded in every new shell"
  else
    echo "   not installed - run:"
    echo "   ln -s \"$(readlink -f "$0")\" ~/.bash_aliases.d/lights.sh"
  fi
  echo
  echo "Device cache (${CACHE_FILE}):"
  if cached="$(cache_read)"; then
    echo "   valid - devices [${cached}], no detection pass needed"
  else
    echo "   absent or stale - the next on/off will re-detect and rebuild it"
  fi
  echo
  echo "Devices openrgb can see:"
  orgb --list-devices 2>/dev/null | grep -E '^[0-9]+:' | sed 's/^/   /' ||
    echo "   (none)"
  echo
  echo "   NZXT hub and Logitech receivers are deliberately hidden from openrgb"
  echo "   (scripts/openrgb/OpenRGB.json) so it cannot disturb fans or mice."
}

# --- dispatch -------------------------------------------------------------

case "${1:-}" in
off)
  echo "Turning lights OFF"
  case_leds off
  smbus_leds 000000
  ;;
on)
  # 'rainbow' is the one asymmetric setting: the case strip can cycle the
  # spectrum, the DIMMs and the board only hold a static colour.
  if [ "${2:-}" = "rainbow" ]; then
    colour="$(resolve_colour "${DEFAULT_ON_COLOUR}")" || exit 1
    mode="spectrum-wave"
  else
    colour="$(resolve_colour "${2:-${DEFAULT_ON_COLOUR}}")" || exit 1
    mode="fixed"
  fi
  echo "Turning lights ON (#${colour})"
  case_leds "${mode}" "${colour}"
  smbus_leds "${colour}"
  ;;
colours | colors)
  list_colours
  ;;
refresh)
  rm -f "${CACHE_FILE}"
  echo "Cache cleared, re-detecting..."
  mapfile -t fresh < <(detect_indices)
  if [ "${#fresh[@]}" -gt 0 ]; then
    cache_write "${fresh[@]}"
    echo "   found ${#fresh[@]} device(s): [${fresh[*]}]"
  else
    echo "   no RAM or motherboard device detected - run 'lights status'"
  fi
  ;;
status)
  show_status
  ;;
*)
  echo "Usage: $(basename "$0") {on [colour|rainbow] | off | status | colours | refresh}" >&2
  exit 1
  ;;
esac

exit 0
