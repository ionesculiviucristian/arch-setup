# shellcheck shell=bash

arch_setup_dir="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
arch_setup_dirs=("${arch_setup_dir}")
arch_setup_repositories_file="${HOME}/.local/state/arch-setup/repositories"

if [ -r "${arch_setup_repositories_file}" ]; then
  while IFS= read -r arch_setup_repository; do
    if [ -d "${arch_setup_repository}" ] && [[ " ${arch_setup_dirs[*]} " != *" ${arch_setup_repository} "* ]]; then
      arch_setup_dirs+=("${arch_setup_repository}")
    fi
  done <"${arch_setup_repositories_file}"
fi

{ true >&3; } 2>/dev/null || exec 3>&1
{ true >&4; } 2>/dev/null || exec 4>/dev/null

# shellcheck source=SCRIPTDIR/log.sh
source "${arch_setup_dir}/lib/log.sh"
# shellcheck source=SCRIPTDIR/file.sh
source "${arch_setup_dir}/lib/file.sh"
# shellcheck source=SCRIPTDIR/env.sh
source "${arch_setup_dir}/lib/env.sh"
# shellcheck source=SCRIPTDIR/request.sh
source "${arch_setup_dir}/lib/request.sh"
# shellcheck source=SCRIPTDIR/grub.sh
source "${arch_setup_dir}/lib/grub.sh"
# shellcheck source=SCRIPTDIR/sudoers.sh
source "${arch_setup_dir}/lib/sudoers.sh"
# shellcheck source=SCRIPTDIR/mounts.sh
source "${arch_setup_dir}/lib/mounts.sh"
# shellcheck source=SCRIPTDIR/fstab.sh
source "${arch_setup_dir}/lib/fstab.sh"
# shellcheck source=SCRIPTDIR/kde.sh
source "${arch_setup_dir}/lib/kde.sh"
# shellcheck source=SCRIPTDIR/bash.sh
source "${arch_setup_dir}/lib/bash.sh"
# shellcheck source=SCRIPTDIR/package.sh
source "${arch_setup_dir}/lib/package.sh"
# shellcheck source=SCRIPTDIR/profile.sh
source "${arch_setup_dir}/lib/profile.sh"
# shellcheck source=SCRIPTDIR/font.sh
source "${arch_setup_dir}/lib/font.sh"
# shellcheck source=SCRIPTDIR/theme.sh
source "${arch_setup_dir}/lib/theme.sh"
# shellcheck source=SCRIPTDIR/installer.sh
source "${arch_setup_dir}/lib/installer.sh"
