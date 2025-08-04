#!/bin/bash
set -eu

# shellcheck disable=SC1091
set -a && source ".env" && set +a

gpgsign=$(gpg \
  --list-secret-keys \
  --keyid-format LONG | \
  grep '^sec' | head -n1 | awk '{print $2}' | cut -d'/' -f2
)

git config --global core.editor "code --wait --new-window"
git config --global diff.tool vscode
# shellcheck disable=SC2016
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global init.defaultBranch main
git config --global merge.tool vscode
# shellcheck disable=SC2016
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

git config --file ~/.gitconfig-personal user.name "${GIT_PERSONAL_USER_NAME:?err}"
git config --file ~/.gitconfig-personal user.email "${GIT_PERSONAL_USER_EMAIL:?err}"

git config --file ~/.gitconfig-personal user.signingkey "${gpgsign}"
git config --file ~/.gitconfig-personal commit.gpgsign true

git config --file ~/.gitconfig-work user.name "${GIT_WORK_USER_NAME:?err}"
git config --file ~/.gitconfig-work user.email "${GIT_WORK_USER_EMAIL:?err}"

cat <<EOF >> ~/.gitconfig

[includeIf "hasconfig:remote.*.url:${GIT_PERSONAL_REMOTE:?err}:*/**"]
    path = ~/.gitconfig-personal

[includeIf "hasconfig:remote.*.url:${GIT_WORK_REMOTE:?err}:*/**"]
    path = ~/.gitconfig-work 
EOF

exit 0
