#!/bin/bash

set -eu

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found!"
    exit 1
fi

sudo -v

sudo pacman -Syu

# ==========================================
# Create directories
# ==========================================

mkdir -p ~/.local/share/fonts
mkdir ~/.repos
mkdir ~/Projects

# ==========================================
# Install fonts
# ==========================================

wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -O ~/.local/share/fonts/JetBrainsMono.tar.xz
tar -xf ~/.local/share/fonts/JetBrainsMono.tar.xz -C ~/.local/share/fonts
rm ~/.local/share/fonts/JetBrainsMono.tar.xz
fc-cache -f -v

# ==========================================
# Install official packages
# ==========================================

sudo pacman -S --noconfirm \
  alacritty \
  atuin \
  bat \
  blender \
  btop \
  code \
  dkms \
  dnsmasq \
  docker \
  docker-compose \
  eza \
  fastfetch \
  fd \
  filezilla \
  firefox \
  flatpak \
  fzf \
  gimp \
  git \
  jq \
  keepassxc \
  krita \
  libreoffice-fresh \
  linux-headers \
  linux-lts-headers \
  lsof \
  ncdu \
  neovim \
  net-tools \
  nvtop \
  obs-studio \
  qbittorrent \
  smplayer \
  starship \
  thunderbird \
  tmux \
  tree \
  unzip \
  virtualbox \
  virtualbox-guest-iso \
  virtualbox-host-dkms \
  zoxide

# ==========================================
# Install mgitstatus
# ==========================================

git clone https://github.com/fboender/multi-git-status.git ~/.repos
cd ~/.repos/multi-git-status
sudo make install

# ==========================================
# Install nvm
# ==========================================

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

nvm install --no-progress 18
nvm install --no-progress 20
nvm install --no-progress 22
nvm use 22
nvm install-latest-npm

# ==========================================
# Install poetry
# ==========================================

curl -sSL https://install.python-poetry.org | python3 -
echo "export PATH=${HOME}/.local/share/pypoetry/venv/bin:\$PATH" > ~/.bashrc

# ==========================================
# Setup Alacritty
# ==========================================

mkdir ~/.config/alacritty
cp dotfiles/.config/alacritty/alacritty.toml ~/.config/alacritty
kwriteconfig6 --file ~/.config/kdeglobals --group General --key TerminalApplication "alacritty"
kwriteconfig6 --file ~/.config/kdeglobals --group General --key TerminalService "Alacritty.desktop"
# kquitapp6 plasmashell
# kstart plasmashell

# ==========================================
# Setup atuin
# ==========================================

wget -qO ~/.bash-preexec.sh https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
echo '[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh' >> ~/.bashrc
echo 'eval "$(atuin init bash)"' >> ~/.bashrc

# ==========================================
# Setup docker
# ==========================================

sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker ${USER}

# ==========================================
# Setup firefox
# ==========================================

firefox -CreateProfile guest
firefox -CreateProfile personal
firefox -CreateProfile work

# ==========================================
# Setup git
# ==========================================

git config --global core.editor "code --wait --new-window"
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global init.defaultBranch main
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'
git config --global user.email "${GIT_USER_EMAIL:-developer@mailpit.localdev}"
git config --global user.name "${GIT_USER_NAME:-Developer}"

# ==========================================
# Setup starship
# ==========================================

echo 'eval "$(starship init bash)"' >> ~/.bashrc
cp dotfiles/.local/share/konsole/Starship.profile ~/.local/share/konsole
kwriteconfig6 --file ~/.config/konsolerc --group "Desktop Entry" --key DefaultProfile Starship.profile
