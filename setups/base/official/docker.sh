#!/bin/bash
set -eu

# [Config] https://docs.docker.com/engine/daemon/#configuration-file
# [Config] https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-docker

sudo usermod -aG docker "${USER}"

docker_dir="/etc/docker"

sudo mkdir -p "${docker_dir}"

sudo cp \
  "./configs/etc/docker/daemon.json" \
  "${docker_dir}/daemon.json"

sudo systemctl enable docker.service
sudo systemctl start docker.service

exit 0
