#!/bin/bash
set -eu

# @see [config](https://docs.docker.com/engine/daemon/#configuration-file)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

docker_dir="/etc/docker"

sudo install -D -m 644 \
  "${package_dir}/config/daemon.json" \
  "${docker_dir}/daemon.json"

sudo usermod -aG docker "${USER}"

sudo systemctl enable docker.service
sudo systemctl restart docker.service

exit 0
