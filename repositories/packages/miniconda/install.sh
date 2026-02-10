#!/bin/bash
set -eu

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

miniconda_dir="${HOME}/miniconda3"

mkdir -p "${miniconda_dir}"

wget \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  -O "${miniconda_dir}/miniconda.sh"

bash "${miniconda_dir}/miniconda.sh" -b -u -p "${miniconda_dir}"

rm "${miniconda_dir}/miniconda.sh"

cp \
  "${root_dir}/repositories/packages/miniconda/config/.condarc" \
  "${HOME}/.condarc"

# shellcheck disable=SC1091
source "${miniconda_dir}/bin/activate"

conda init --all

exit 0
