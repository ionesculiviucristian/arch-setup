#!/bin/bash
set -eu

# [config] https://docs.docker.com/engine/daemon/#configuration-file

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

docker_dir="/etc/docker"

sudo mkdir -p "${docker_dir}"

sudo cp \
  "${package_dir}/config/daemon.json" \
  "${docker_dir}/daemon.json"

sudo usermod -aG docker "${USER}"

sudo systemctl enable --now docker.service

exit 0
