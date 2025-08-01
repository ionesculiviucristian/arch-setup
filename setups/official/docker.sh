#!/bin/bash
set -eu

# [Config] https://docs.docker.com/engine/daemon/#configuration-file
# [Config] https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-docker

# shellcheck disable=SC1091
source "./scripts/helpers.sh"

docker_dir="/etc/docker"

if is_kernel_outdated; then
  echo "Docker setup must be ran manually," \
  "after restart, because the LTS kernel got updated"
  exit 0
fi

sudo mkdir -p "${docker_dir}"

sudo cp \
  "./configs/etc/docker/daemon.json" \
  "${docker_dir}/daemon.json"

sudo systemctl enable docker.service
sudo systemctl start docker.service

sudo usermod -aG docker "${USER}"

if command -v nvidia-ctk >/dev/null; then
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
fi

exit 0
