#!/bin/bash
set -eu

# @see [config](https://man.archlinux.org/man/sshd_config.5)

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

sudo install -D -m 644 \
  "${package_dir}/config/10-arch-setup.conf" \
  "/etc/ssh/sshd_config.d/10-arch-setup.conf"

sudo systemctl start sshdgenkeys.service

sudo sshd -t

sudo systemctl enable sshd.service
sudo systemctl restart sshd.service

exit 0
