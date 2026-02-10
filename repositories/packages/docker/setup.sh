#!/bin/bash
set -eu

# [config] https://docs.docker.com/engine/daemon/#configuration-file

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

docker_dir="/etc/docker"

sudo mkdir -p "${docker_dir}"

sudo cp \
  "${root_dir}/repositories/packages/docker/config/daemon.json" \
  "${docker_dir}/daemon.json"

sudo usermod -aG docker "${USER}"

sudo systemctl enable --now docker.service

exit 0
