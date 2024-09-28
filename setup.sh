#!/bin/bash

set -eux

mkdir -p ~/.local/share/fonts
mkdir ~/.repos
mkdir ~/Projects

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -O ~/.local/share/fonts/JetBrainsMono.tar.xz
tar -xf ~/.local/share/fonts/JetBrainsMono.tar.xz -C ~/.local/share/fonts
rm ~/.local/share/fonts/JetBrainsMono.tar.xz
fc-cache -f -v

sudo pacman -Syu

sudo pacman -S --noconfirm \
  firefox \
  neovim \
  code \
  docker \
  docker-compose \
  keepassxc \
  qbittorrent \
  python-pip

sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 18
nvm install 20
nvm install 22
nvm use 22
nvm install-latest-npm


