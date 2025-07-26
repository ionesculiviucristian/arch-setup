#!/bin/bash
set -eu

# https://docs.docker.com/engine/daemon/#configuration-file
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-docker

# shellcheck disable=SC1091
source "./scripts/helpers.sh" 2

docker_dir="/etc/docker"

_mkdir_sudo "${docker_dir}"

_cp_sudo \
  "./configs/etc/docker/daemon.json" \
  "${docker_dir}/daemon.json"

service_enable docker.service 2>&1 | tee -a "./install.log" >/dev/null
service_start docker.service

sudo usermod -aG docker "${USER}"

if command -v nvidia-ctk >/dev/null 2>&1; then
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
fi

exit 0
