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

sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings

# https://wiki.archlinux.org/title/NVIDIA#pacman_hook
sudo tee /etc/pacman.d/hooks/nvidia.hook > /dev/null <<EOF
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
# Uncomment the installed NVIDIA package
Target=nvidia
#Target=nvidia-open
#Target=nvidia-lts
# If running a different kernel, modify below to match
Target=linux

[Action]
Description=Updating NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case \$trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF

sudo pacman -S --noconfirm \
  atuin \
  base-devel \
  bat \
  btop \
  dnsmasq \
  eza \
  fastfetch \
  firefox \
  fzf \
  git \
  neovim \
  code \
  docker \
  docker-compose \
  jq \
  keepassxc \
  qbittorrent \
  ncdu \
  nvidia-container-toolkit \
  nvtop \
  steam \
  smplayer \
  transmission-qt \
  tree \
  yakuake
  # virtualbox virtualbox-host-dkms 

echo 'eval "$(atuin init bash)"' >> ~/.bashrc

sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

# https://wiki.archlinux.org/title/Gaming#Increase_vm.max_map_count
echo "vm.max_map_count = 2147483642" | sudo tee /etc/sysctl.d/80-gamecompatibility.conf > /dev/null
sudo sysctl --system

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 18
nvm install 20
nvm install 22
nvm use 22
nvm install-latest-npm

cd ~/.repos
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -Syu apache-tools amd-ucode

git config --global user.name "Ionescu Liviu Cristian"
git config --global user.email "$(echo bGl2aXVAcHVycGxlY2F0LWxhYnMuY29t | base64 --decode)"
git config --global init.defaultBranch main
git config --global core.editor "code --wait --new-window"
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
