#!/bin/bash
set -eu

package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
root_dir="${package_dir%/repositories/*}"

go install github.com/a-h/templ/cmd/templ@latest
go install github.com/air-verse/air@latest
go install github.com/google/go-jsonnet/cmd/jsonnet@latest
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install golang.org/x/tools/gopls@latest

"${root_dir}/scripts/setup_shell.sh" \
  --package "go" \
  --priority "20" \
  "${package_dir}/bashrc.sh"

exit 0
