#!/bin/bash
set -eu

# [Config] https://docs.docker.com/engine/daemon/#configuration-file
# [Config] https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-docker

docker_dir="/etc/docker"

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
