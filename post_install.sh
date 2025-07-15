#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
  echo "Usage: $0 <EMAIL>"
  exit 1
fi

EMAIL="$1"

# shellcheck disable=SC1091
source "${HOME}/.bashrc"

BW_SESSION=$(bw login "${EMAIL}" --method 0 --raw)
export BW_SESSION

bw get item "Private bash aliases" | jq -r '.notes' > "${HOME}/.bash_private_aliases"
bw get item "Arch setup" | jq -r '.notes' > \.env
bw get item "GPG private key" | jq -r '.notes' | gpg --import
bw get item "GPG public key" | jq -r '.notes' | gpg --import

bw logout

# shellcheck disable=SC1091
set -a && source ".env" && set +a

# ==========================================
# Setup git
# ==========================================

git config --global core.editor "code --wait --new-window"
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global init.defaultBranch main
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

git config --file ~/.gitconfig-personal user.name "${GIT_PERSONAL_USER:?err}"
git config --file ~/.gitconfig-personal user.email "${GIT_PERSONAL_USER_EMAIL:?err}"
git config --file ~/.gitconfig-personal user.signingkey "$(gpg --list-secret-keys --keyid-format LONG | grep '^sec' | head -n1 | awk '{print $2}' | cut -d'/' -f2)"
git config --file ~/.gitconfig-personal commit.gpgsign true

git config --file ~/.gitconfig-work user.name "${GIT_WORK_USER:?err}"
git config --file ~/.gitconfig-work user.email "${GIT_WORK_USER_EMAIL:?err}"

cat <<EOF >> ~/.gitconfig

[includeIf "hasconfig:remote.*.url:${GIT_PERSONAL_REMOTE:?err}:*/**"]
    path = ~/.gitconfig-personal

[includeIf "hasconfig:remote.*.url:${GIT_WORK_REMOTE:?err}:*/**"]
    path = ~/.gitconfig-work 
EOF
