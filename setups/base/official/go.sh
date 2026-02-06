#!/bin/bash
set -eu

go install github.com/a-h/templ/cmd/templ@latest
go install github.com/air-verse/air@latest
go install github.com/google/go-jsonnet/cmd/jsonnet@latest
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install golang.org/x/tools/gopls@latest

./scripts/update_bashrc.sh "go" <<'EOF'
export PATH="${HOME}/go/bin:${PATH}"
EOF

exit 0
