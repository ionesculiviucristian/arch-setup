#!/bin/bash
set -eu

if [ -f .env ]; then
  set -a
  source .env
  set +a
else
  echo "Error: .env file not found!"
  exit 1
fi

# ==========================================
# Create directories
# ==========================================

mkdir ~/.bash_aliases.d
mkdir -p ~/.local/share/fonts
mkdir ~/.repos
mkdir ~/Backups
mkdir ~/Projects

cp ./configs/.bashrc ~/.bashrc

./add_places_entry.sh /home/liviu/Backups "Backups"
./add_places_entry.sh /home/liviu/Projects "Projects"

# ==========================================
# Install fonts
# ==========================================

./install_font.sh https://github.com/eigilnikolajsen/commit-mono/releases/download/v1.143/CommitMono-1.143.zip
./install_font.sh https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz

# ==========================================
# Install official packages
# ==========================================

sudo pacman -Syu --needed --noconfirm \
  atuin \
  base-devel \
  bash-completion \
  bat \
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
  jq \
  keepassxc \
  kitty \
  kpackage \
  krita \
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
# Install ble.sh
# ==========================================

git clone --recursive https://github.com/akinomyoga/ble.sh.git ~/.repos/ble.sh
cd ~/.repos/ble.sh
make
make INSDIR="${HOME}/.local/share/blesh" install
touch ${HOME}/.blerc

echo '[[ $- == *i* ]] && source "${HOME}/.local/share/blesh/ble.sh" --rcfile "${HOME}/.blerc"' >> ~/.bashrc
echo '[[ ! ${BLE_VERSION-} ]] || ble-attach' >> ~/.bashrc

# ==========================================
# Install mgitstatus
# ==========================================

git clone https://github.com/fboender/multi-git-status.git ~/.repos/multi-git-status
cd ~/.repos/multi-git-status
sudo make install

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

curl -sSL https://install.python-poetry.org | python3 -
echo "export PATH=${HOME}/.local/share/pypoetry/venv/bin/poetry:\$PATH" >> ~/.bashrc

# ==========================================
# Install yay
# ==========================================

git clone https://aur.archlinux.org/yay.git ~/.repos/yay
cd ~/.repos/yay
makepkg -si

# ==========================================
# Install AUR packages
# ==========================================

yay -Syu --needed --noconfirm \
  brave-bin \
  papirus-icon-theme \
  postman-bin \
  spotify \
  tdrop \
  visual-studio-code-bin 

# ==========================================
# Setup GRUB
# ==========================================

sudo sed -i 's/^GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' /etc/default/grub
sudo sed -i 's/^#GRUB_SAVEDEFAULT=true/GRUB_SAVEDEFAULT=true/' /etc/default/grub
sudo sed -i 's/^#GRUB_DISABLE_SUBMENU=y/GRUB_DISABLE_SUBMENU=y/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# ==========================================
# Setup Konsole
# ==========================================

wget -qO \
  ~/.local/share/konsole/catppuccin-mocha.colorscheme \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme
cp configs/.local/share/konsole/Starship.profile ~/.local/share/konsole
kwriteconfig6 --file ~/.config/konsolerc --group "Desktop Entry" --key DefaultProfile Starship.profile

# ==========================================
# Setup Night Color
# ==========================================

kwriteconfig6 --file ~/.config/kwinrc --group "NightColor" --key Active true
kwriteconfig6 --file ~/.config/kwinrc --group "NightColor" --key DayTemperature 5700
kwriteconfig6 --file ~/.config/kwinrc --group "NightColor" --key LatitudeFixed 45.65
kwriteconfig6 --file ~/.config/kwinrc --group "NightColor" --key LongitudeFixed 25.63
kwriteconfig6 --file ~/.config/kwinrc --group "NightColor" --key Mode "Location"
kwriteconfig6 --file ~/.config/kwinrc --group "NightColor" --key NightTemperature 3500

# ==========================================
# Setup atuin
# ==========================================

mkdir -p ~/.config/atuin/themes
wget -qO \
  ~/.config/atuin/themes/catppuccin-mocha-mauve.toml \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 
cp configs/.config/atuin/config.toml ~/.config/atuin/config.toml
echo 'eval "$(atuin init bash)"' >> ~/.bashrc

# ==========================================
# Setup bat
# ==========================================

mkdir -p ~/.config/bat/themes
wget -qO \
  ~/.config/bat/themes/Catppuccin\ Mocha.tmTheme \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build
cp configs/.config/bat/config ~/.config/bat/config

# ==========================================
# Setup btop
# ==========================================

mkdir -p ~/.config/btop/themes
wget -qO \
  ~/.config/btop/themes/catppuccin_mocha.theme \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme
cp configs/.config/btop/btop.conf ~/.config/btop/btop.conf

# ==========================================
# Setup Catppuccin theme
# ==========================================

git clone --depth=1 https://github.com/catppuccin/kde ~/.repos/catppuccin-kde
cd ~/.repos/catppuccin-kde
./install.sh 1 4 2

# ==========================================
# Setup Papirus icon theme
# ==========================================

wget -qO- https://git.io/papirus-folders-install | sh
kwriteconfig6 --file ~/.config/kdeglobals --group Icons --key Theme "Papirus-Dark"
papirus-folders -C violet --theme Papirus-Dark

# ==========================================
# Setup direnv
# ==========================================

echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

# ==========================================
# Setup docker
# ==========================================

sudo mkdir /etc/docker
sudo cp configs/etc/docker/daemon.json /etc/docker/daemon.json
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker ${USER}

# ==========================================
# Setup NVIDIA Container Toolkit
# ==========================================

if command -v nvidia-ctk >/dev/null 2>&1; then
    sudo nvidia-ctk runtime configure --runtime=docker
    sudo systemctl restart docker
fi

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
# Setup kitty
# ==========================================

mkdir -p ~/.config/kitty/themes
wget -qO \
  ~/.config/kitty/themes/mocha.conf \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf
cp configs/.config/kitty/kitty.conf ~/.config/kitty
kwriteconfig6 --file ~/.config/kdeglobals --group General --key TerminalApplication "kitty"
kwriteconfig6 --file ~/.config/kdeglobals --group General --key TerminalService "kitty.desktop"
echo '[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"' >> ~/.bashrc

# ==========================================
# Setup mkcert
# ==========================================

mkcert -install

# ==========================================
# Setup starship
# ==========================================

mkdir -p ~/.config/starship/themes
wget -qO \
  ~/.config/starship/themes/mocha.conf \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml
cp configs/.config/starship/config.toml ~/.config/starship/config.toml
touch ~/.config/.starship.toml
cat \
  ~/.config/starship/config.toml \
  ~/.config/starship/themes/mocha.conf \
  > ~/.config/.starship.toml
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# ==========================================
# Setup superfile
# ==========================================

mkdir -p ~/.config/superfile/theme
wget -qO \
  ~/.config/superfile/theme/catppuccin-mocha-mauve.toml \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml
cp configs/.config/superfile/config.toml ~/.config/superfile/config.toml
   
# ==========================================
# Setup tmux
# ==========================================

mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
git clone https://github.com/tmux-plugins/tmux-cpu ~/.config/tmux/plugins/tmux-plugins/tmux-cpu
git clone https://github.com/tmux-plugins/tmux-battery ~/.config/tmux/plugins/tmux-plugins/tmux-battery
cp configs/.tmux.conf ~/.tmux.conf
