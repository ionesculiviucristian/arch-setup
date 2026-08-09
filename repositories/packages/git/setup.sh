#!/bin/bash
set -eu

# @see [config](https://git-scm.com/docs/git-config)

git config --global core.editor "code --wait --new-window"
git config --global diff.tool vscode
git config --global difftool.vscode.cmd "code --wait --diff \$LOCAL \$REMOTE"
git config --global fetch.prune true
git config --global init.defaultBranch main
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait \$MERGED"
git config --global pull.rebase true
git config --global push.autoSetupRemote true

exit 0
