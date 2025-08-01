#!/bin/bash
set -eu

host=$1

hosts_file="/etc/hosts"

if ! grep -Fxq "${host}" "${hosts_file}"; then
  echo "${host}" | sudo tee -a "${hosts_file}" >/dev/null
fi

exit 0
