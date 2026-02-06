#!/bin/bash
set -eu

# [Config] https://docs.docker.com/engine/daemon/#configuration-file

# shellcheck source=../_config.sh
source "./setups/base/_config.sh"

sudo usermod -aG docker "${USER}"

sudo mkdir -p "${docker_dir}"

sudo cp \
  "./configs/etc/docker/daemon.json" \
  "${docker_dir}/daemon.json"

sudo systemctl enable --now docker.service

exit 0
