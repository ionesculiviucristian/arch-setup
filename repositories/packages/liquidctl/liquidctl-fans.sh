#!/bin/bash
set -eu

config_file="${LIQUIDCTL_FANS_CONFIG:-/etc/liquidctl-fans.yml}"
device=$(yq -r '.device' "${config_file}")

wait_for_device() {
  local tries=0

  until liquidctl list | grep -qF "${device}"; do
    if ((tries++ >= 10)); then
      echo "${device} did not appear" >&2
      exit 1
    fi
    sleep 2
  done

  liquidctl --match "${device}" initialize >/dev/null
}

device_channels() {
  liquidctl --match "${device}" status --json |
    yq -p=json -r '.[0].status[].key | select(test("^Fan [0-9]+ speed$")) | "fan" + split(" ")[1]'
}

fan_name() {
  CHANNEL=$1 yq -r '.fans[] | select(.channel == env(CHANNEL)) | .name' "${config_file}"
}

apply_profile() {
  wait_for_device

  local channel speed name
  while IFS=$'\t' read -r channel speed name; do
    echo "${channel} (${name}) at ${speed}%"
    liquidctl --match "${device}" set "${channel}" speed "${speed}"
  done < <(yq -r '.fans[] | [.channel, .speed, .name] | @tsv' "${config_file}")
}

identify_fans() {
  wait_for_device

  local channels channel name
  channels=$(device_channels)

  for channel in ${channels}; do
    liquidctl --match "${device}" set "${channel}" speed 30
  done
  sleep 3

  for channel in ${channels}; do
    name=$(fan_name "${channel}")
    echo "${channel}${name:+ (${name})} at 100% for 6 seconds"
    liquidctl --match "${device}" set "${channel}" speed 100
    sleep 6
    liquidctl --match "${device}" set "${channel}" speed 30
    sleep 2
  done

  apply_profile
}

case "${1:-apply}" in
apply) apply_profile ;;
status) liquidctl --match "${device}" status ;;
identify) identify_fans ;;
*)
  echo "Unknown command: '$1'. Use: apply | status | identify" >&2
  exit 1
  ;;
esac

exit 0
