#!/bin/bash
set -eu

host=$1

if [ -z "${host}" ]; then
  echo "Error: Host is required"
  exit 1
fi

hosts_file="/etc/hosts"

if ! grep -qFx "${host}" "${hosts_file}"; then
  echo "${host}" | sudo tee -a "${hosts_file}" >/dev/null
fi

exit 0
