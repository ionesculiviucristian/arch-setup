#!/bin/bash
set -eu

docker_dir="/etc/docker"

sudo mkdir -p "${docker_dir}"

sudo cp \
  "./configs/etc/docker/daemon.json" \
  "${docker_dir}/daemon.json"

sudo systemctl start docker.service
sudo systemctl enable docker.service

sudo usermod -aG docker "${USER}"

if command -v nvidia-ctk >/dev/null 2>&1; then
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
fi

exit 0
