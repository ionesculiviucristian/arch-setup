#!/bin/bash
set -eu

# Preload the filesystem modules used by /etc/fstab.
#
# On-demand module autoloading (request_module) can intermittently fail during
# the udev coldplug storm at boot, which makes mounts die with
# "unknown filesystem type '<fs>'". For a pass!=0 mount like /boot that fails
# local-fs.target and drops the system into emergency mode.
#
# systemd-modules-load runs long before local-fs.target, so listing the modules
# here guarantees they are in the kernel by the time the mounts run.
# See docs/NOTES.md.
#
# nls_cp437 / nls_ascii are built into the Arch kernel, so they never autoload
# and are deliberately not listed.

modules_file="/etc/modules-load.d/filesystems.conf"

sudo tee "${modules_file}" >/dev/null <<'EOF'
# Managed by arch-setup (os/scripts/setup_kernel_modules.sh)
vfat
ntfs3
EOF

sudo systemctl restart systemd-modules-load.service

exit 0
