#!/bin/bash
set -eu

PASSWORDLESS_SUDO="/etc/sudoers.d/$(whoami)"

echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee -a ${PASSWORDLESS_SUDO}

cp "./configs/.bashrc" "${HOME}/.bashrc"

# ==========================================
# Create directories
# ==========================================

mkdir -p "${HOME}/.bash_aliases.d"
mkdir -p "${HOME}/.local/share/fonts"
mkdir -p "${HOME}/.repos"
mkdir -p "${HOME}/.wallpapers"
mkdir -p "${HOME}/Backups"
mkdir -p "${HOME}/Projects"

./add_places_entry.sh "${HOME}/Backups" "Backups"
./add_places_entry.sh "${HOME}/Projects" "Projects"

# ==========================================
# Install packages
# ==========================================

sudo pacman -Syu --needed --noconfirm \
  atuin \
  base-devel \
  bash-completion \
  bat \
  bitwarden-cli \
  blender \
  broot \
  btop \
  direnv \
  dkms \
  dnsmasq \
  docker \
  docker-compose \
  expac \
  eza \
  fastfetch \
  fd \
  filezilla \
  firefox \
  fzf \
  gimp \
  git \
  go-yq \
  jq \
  kcalc \
  keepassxc \
  kitty \
  kpackage \
  krita \
  lazygit \
  less \
  libreoffice-fresh \
  linux-headers \
  linux-lts-headers \
  lsof \
  mkcert \
  ncdu \
  neovim \
  net-tools \
  nss \
  ntfs-3g \
  nvtop \
  obs-studio \
  partitionmanager \
  qbittorrent \
  ripgrep \
  rsync \
  smplayer \
  solaar \
  starship \
  superfile \
  thunderbird \
  tmux \
  tmuxp \
  unzip \
  virtualbox \
  virtualbox-guest-iso \
  virtualbox-host-dkms \
  zip \
  zoxide

# ==========================================
# Install yay
# ==========================================

git clone https://aur.archlinux.org/yay.git "${HOME}/.repos/yay"

(
  cd "${HOME}/.repos/yay"
  makepkg -si --needed --noconfirm
)

# ==========================================
# Install AUR packages
# ==========================================

yay -Syu --needed --noconfirm \
  bitwarden-bin \
  brave-bin \
  papirus-icon-theme \
  postman-bin \
  spotify \
  tdrop \
  visual-studio-code-bin 

# ==========================================
# Install fonts
# ==========================================

./install_font.sh https://github.com/eigilnikolajsen/commit-mono/releases/download/v1.143/CommitMono-1.143.zip
./install_font.sh https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz

# ==========================================
# Install themes
# ==========================================

./install_themes.sh

# ==========================================
# Install ble.sh
# ==========================================

git clone --recursive https://github.com/akinomyoga/ble.sh.git "${HOME}/.repos/ble.sh"

(
  cd "${HOME}/.repos/ble.sh"
  make
  make INSDIR="${HOME}/.local/share/blesh" install
)

touch "${HOME}/.blerc"

echo '[[ $- == *i* ]] && source "${HOME}/.local/share/blesh/ble.sh" --rcfile "${HOME}/.blerc"' >> "${HOME}/.bashrc"
echo '[[ ! ${BLE_VERSION-} ]] || ble-attach' >> "${HOME}/.bashrc"

# ==========================================
# Install mgitstatus
# ==========================================

git clone https://github.com/fboender/multi-git-status.git "${HOME}/.repos/multi-git-status"

(
  cd "${HOME}/.repos/multi-git-status"
  sudo make install
)

# ==========================================
# Install nvm
# ==========================================

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

nvm install --no-progress 18
nvm install --no-progress 20
nvm install --no-progress 22
nvm install --no-progress 24

nvm use 24

nvm install-latest-npm

# ==========================================
# Install poetry
# ==========================================

wget -qO- https://install.python-poetry.org | python3 -

echo 'export PATH="${HOME}/.local/share/pypoetry/venv/bin/poetry":${PATH}' >> "${HOME}/.bashrc"

# ==========================================
# Setup GRUB
# ==========================================

sudo sed -i 's/^GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' "/etc/default/grub"
sudo sed -i 's/^#GRUB_SAVEDEFAULT=true/GRUB_SAVEDEFAULT=true/' "/etc/default/grub"
sudo sed -i 's/^#GRUB_DISABLE_SUBMENU=y/GRUB_DISABLE_SUBMENU=y/' "/etc/default/grub"

sudo grub-mkconfig -o "/boot/grub/grub.cfg"

# ==========================================
# Setup Konsole
# ==========================================

mkdir -p "${HOME}/.local/share/konsole"

cp "configs/.local/share/konsole/Starship.profile" "${HOME}/.local/share/konsole"

kwriteconfig6 --file "${HOME}/.config/konsolerc" --group "Desktop Entry" --key "DefaultProfile" "Starship.profile"

# ==========================================
# Setup Night Color
# ==========================================

kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "Active" true
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "DayTemperature" 5700
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "LatitudeFixed" 45.65
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "LongitudeFixed" 25.63
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "Mode" "Location"
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "NightTemperature" 3500

# ==========================================
# Setup SDDM 
# ==========================================

sudo cp "configs/etc/sddm.conf" "/etc/sddm.conf"

# ==========================================
# Setup atuin
# ==========================================

mkdir -p "${HOME}/.config/atuin"

cp "configs/.config/atuin/config.toml" "${HOME}/.config/atuin/config.toml"

echo 'eval "$(atuin init bash)"' >> "${HOME}/.bashrc"

# ==========================================
# Setup bat
# ==========================================

mkdir -p "${HOME}/.config/bat"

cp "configs/.config/bat/config" "${HOME}/.config/bat/config"

# ==========================================
# Setup Bitwarden
# ==========================================

echo 'export SSH_AUTH_SOCK="${HOME}/.bitwarden-ssh-agent.sock"' >> "${HOME}/.bashrc"

# ==========================================
# Setup btop
# ==========================================

mkdir -p "${HOME}/.config/btop"

cp "configs/.config/btop/btop.conf" "${HOME}/.config/btop/btop.conf"

# ==========================================
# Setup direnv
# ==========================================

echo 'eval "$(direnv hook bash)"' >> "${HOME}/.bashrc"

# ==========================================
# Setup docker
# ==========================================

sudo mkdir -p "/etc/docker"

sudo cp "configs/etc/docker/daemon.json" "/etc/docker/daemon.json"

sudo systemctl start docker.service
sudo systemctl enable docker.service

sudo usermod -aG docker "${USER}"

# ==========================================
# Setup kitty
# ==========================================

mkdir -p "${HOME}/.config/kitty"

cp "configs/.config/kitty/kitty.conf" "${HOME}/.config/kitty"

kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "General" --key "TerminalApplication" "kitty"
kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "General" --key "TerminalService" "kitty.desktop"

echo '[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"' >> "${HOME}/.bashrc"

# ==========================================
# Setup mkcert
# ==========================================

mkcert -install

# ==========================================
# Setup neovim 
# ==========================================

sudo pacman -Syu --needed --noconfirm luarocks

cp -r "configs/.config/nvim" "${HOME}/.config"

# ==========================================
# Setup NVIDIA Container Toolkit
# ==========================================

if command -v nvidia-ctk >/dev/null 2>&1; then
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
fi

# ==========================================
# Setup starship
# ==========================================

mkdir -p "${HOME}/.config/starship"

cp "configs/.config/starship/config.toml" "${HOME}/.config/starship/config.toml"

touch "${HOME}/.config/.starship.toml"

if [ -f "${HOME}/.config/starship/themes/mocha.conf" ]; then
  cat \
    "${HOME}/.config/starship/config.toml" \
    "${HOME}/.config/starship/themes/mocha.conf" \
    > "${HOME}/.config/.starship.toml"
fi

echo 'eval "$(starship init bash)"' >> "${HOME}/.bashrc"

# ==========================================
# Setup superfile
# ==========================================

mkdir -p "${HOME}/.config/superfile"

cp "configs/.config/superfile/config.toml" "${HOME}/.config/superfile/config.toml"

# ==========================================
# Setup tdrop
# ==========================================

mkdir -p "${HOME}/.local/share/applications"

cp "configs/.local/share/applications/net.local.tdrop.desktop" "${HOME}/.local/share/applications/net.local.tdrop.desktop"

kwriteconfig6 --file "${HOME}/.config/kglobalshortcutsrc" --group "services" --group "net.local.tdrop.desktop" --key "_launch" "Alt+F12"

# ==========================================
# Setup tmux
# ==========================================

mkdir -p "${HOME}/.config/tmux/plugins//tmux-plugins"

git clone https://github.com/tmux-plugins/tmux-cpu "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-cpu"
git clone https://github.com/tmux-plugins/tmux-battery "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-battery"

cp "configs/.tmux.conf" "${HOME}/.tmux.conf"

# ==========================================
# Setup vim 
# ==========================================

cp "configs/.vimrc" "${HOME}/.vimrc"

# ==========================================
# Post install
# ==========================================

./install_aliases.sh

sudo rm ${PASSWORDLESS_SUDO}
