#!/bin/bash
set -eu

# Cap the size of the systemd journal.
#
# With no SystemMaxUse, journald falls back to 10% of the filesystem, which is
# ~23 GB on this 250 GB disk — a limit large enough that it never kicks in
# before the disk itself fills up. See docs/NOTES.md.
#
# 500M keeps a few weeks of logs, which is well past what is useful for
# debugging a boot or a service that died yesterday.

journald_config_dir="/etc/systemd/journald.conf.d"

sudo mkdir -p "${journald_config_dir}"

sudo tee "${journald_config_dir}/00-size.conf" >/dev/null <<'EOF'
# Managed by arch-setup (os/scripts/setup_journald.sh)
[Journal]
SystemMaxUse=500M
EOF

sudo systemctl restart systemd-journald

exit 0
