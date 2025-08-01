#!/bin/bash
set -eu

# [Config] https://docs.docker.com/engine/daemon/#configuration-file
# [Config] https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuring-docker

docker_dir="/etc/docker"

# This seems to be the first time we setup docker.
# Chances are that the LTS kernel got updated and that
# will most likely raise errors when trying to start docker
# so this script will be need to be ran manually, after restart 
if [ ! -f "${docker_dir}/daemon.json" ]; then
  installed_kernel=$(pacman -Q linux-lts | awk '{print $2}')
  running_kernel=$(uname -r)

  if [[ "${running_kernel}" != *"${installed_kernel}"* ]]; then
    echo "Docker setup must be ran manually," \
    "after restart, because the LTS kernel got updated"
    exit 0
  fi
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
