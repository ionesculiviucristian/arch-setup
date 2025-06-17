#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
  echo "Usage: $0 your-email@example.com"
  exit 1
fi

EMAIL="$1"

cp "./configs/.bashrc" "${HOME}/.bashrc"

echo "export BW_EMAIL=${EMAIL}" >> "${HOME}/.bashrc"
source "${HOME}/.bashrc"

export BW_SESSION=$(bw login ${BW_EMAIL} --method 0 --raw)

bw get item "GPG private key" | jq -r '.notes' | gpg --import
bw get item "GPG public key" | jq -r '.notes' | gpg --import
bw get item arch-setup | jq -r '.notes' > \.env

bw logout

set -a && source ".env" && set +a

# ==========================================
# Create directories
# ==========================================

mkdir "${HOME}/.bash_aliases.d"
mkdir -p "${HOME}/.local/share/fonts"
mkdir "${HOME}/.repos"
mkdir "${HOME}/Backups"
mkdir "${HOME}/Projects"

./add_places_entry.sh "${HOME}/Backups" "Backups"
./add_places_entry.sh "${HOME}/Projects" "Projects"

# ==========================================
# Install fonts
# ==========================================

./install_font.sh https://github.com/eigilnikolajsen/commit-mono/releases/download/v1.143/CommitMono-1.143.zip
./install_font.sh https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz

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
# Install ble.sh
# ==========================================

git clone --recursive https://github.com/akinomyoga/ble.sh.git "${HOME}/.repos/ble.sh"

(
  cd "${HOME}/.repos/ble.sh"
  make
  make INSDIR="${HOME}/.local/share/blesh" install
  touch "${HOME}/.blerc"
)

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

curl -sSL https://install.python-poetry.org | python3 -

echo 'export PATH="${HOME}/.local/share/pypoetry/venv/bin/poetry":${PATH}' >> "${HOME}/.bashrc"

# ==========================================
# Install yay
# ==========================================

git clone https://aur.archlinux.org/yay.git "${HOME}/.repos/yay"

(
  cd "${HOME}/.repos/yay"
  makepkg -si
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
# Setup GRUB
# ==========================================

git clone https://github.com/catppuccin/grub.git "${HOME}/.repos/catppuccin-grub"

sudo cp -r "${HOME}/.repos/catppuccin-grub/src/catppuccin-mocha-grub-theme" "/usr/share/grub/themes/catppuccin-mocha-grub-theme"

sudo sed -i 's/^GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' "/etc/default/grub"
sudo sed -i 's/^#GRUB_SAVEDEFAULT=true/GRUB_SAVEDEFAULT=true/' "/etc/default/grub"
sudo sed -i 's/^#GRUB_DISABLE_SUBMENU=y/GRUB_DISABLE_SUBMENU=y/' "/etc/default/grub"
sudo sed -i 's|^#GRUB_THEME="/path/to/gfxtheme"|GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"|' "/etc/default/grub"

sudo grub-mkconfig -o "/boot/grub/grub.cfg"

# ==========================================
# Setup Konsole
# ==========================================

wget -qO \
  "${HOME}/.local/share/konsole/catppuccin-mocha.colorscheme" \
  https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme

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

sudo pacman -Syu --needed --noconfirm \
  qt6-svg \
  qt6-declarative \
  qt5-quickcontrols2

wget -qO- https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.zip | sudo bsdtar -xvf- -C "/usr/share/sddm/themes"

sudo sed -i \
  -e 's/^CustomBackground="false"/CustomBackground="true"/' \
  -e 's/^LoginBackground="false"/LoginBackground="true"/' \
  "/usr/share/sddm/themes/catppuccin-mocha/theme.conf"

sudo cp "configs/etc/sddm.conf" "/etc/sddm.conf"
sudo cp "wallpapers/UltrawideWallpapersDotNet-1128.jpeg" "/usr/share/sddm/themes/catppuccin-mocha/backgrounds/wall.jpg"

# ==========================================
# Setup atuin
# ==========================================

mkdir -p "${HOME}/.config/atuin/themes"

wget -qO \
  "${HOME}/.config/atuin/themes/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/atuin/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml 

cp "configs/.config/atuin/config.toml" "${HOME}/.config/atuin/config.toml"

echo 'eval "$(atuin init bash)"' >> "${HOME}/.bashrc"

# ==========================================
# Setup bat
# ==========================================

mkdir -p "${HOME}/.config/bat/themes"

wget -qO \
  "${HOME}/.config/bat/themes/Catppuccin Mocha.tmTheme" \
  https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

bat cache --build

cp "configs/.config/bat/config" "${HOME}/.config/bat/config"

# ==========================================
# Setup Bitwarden
# ==========================================

echo 'export SSH_AUTH_SOCK="${HOME}/.bitwarden-ssh-agent.sock"' >> "${HOME}/.bashrc"

# ==========================================
# Setup btop
# ==========================================

mkdir -p "${HOME}/.config/btop/themes"

wget -qO \
  "${HOME}/.config/btop/themes/catppuccin_mocha.theme" \
  https://raw.githubusercontent.com/catppuccin/btop/refs/heads/main/themes/catppuccin_mocha.theme

cp "configs/.config/btop/btop.conf" "${HOME}/.config/btop/btop.conf"

# ==========================================
# Setup Catppuccin theme
# ==========================================

git clone --depth=1 https://github.com/catppuccin/kde "${HOME}/.repos/catppuccin-kde"

(
  cd "${HOME}/.repos/catppuccin-kde"
  printf "1\n4\n2\ny\ny" | ./install.sh

  # cd "$HOME/.icons"
  # curl -LOsS https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-mauve-cursors.zip
  # unzip "catppuccin-mocha-mauve-cursors.zip"
  # rm "catppuccin-mocha-mauve-cursors.zip"
)

# ==========================================
# Setup direnv
# ==========================================

echo 'eval "$(direnv hook bash)"' >> "${HOME}/.bashrc"

# ==========================================
# Setup docker
# ==========================================

sudo mkdir "/etc/docker"

sudo cp "configs/etc/docker/daemon.json" "/etc/docker/daemon.json"

sudo systemctl start docker.service
sudo systemctl enable docker.service

sudo usermod -aG docker "${USER}"

# ==========================================
# Setup fzf
# ==========================================
 
git clone https://github.com/catppuccin/fzf.git "${HOME}/.repos/catppuccin-fzf"

echo 'source "${HOME}/.repos/catppuccin-fzf/themes/catppuccin-fzf-mocha.sh"' >> "${HOME}/.bashrc"

# ==========================================
# Setup git
# ==========================================

git config --global core.editor "code --wait --new-window"
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global init.defaultBranch main
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

git config --file ~/.gitconfig-personal user.name "${GIT_PERSONAL_USER_NAME:?err}"
git config --file ~/.gitconfig-personal user.email "${GIT_PERSONAL_USER_EMAIL:?err}"
git config --file ~/.gitconfig-personal user.signingkey $(gpg --list-secret-keys --keyid-format LONG | grep '^sec' | head -n1 | awk '{print $2}' | cut -d'/' -f2)
git config --file ~/.gitconfig-personal commit.gpgsign true

git config --file ~/.gitconfig-work user.name "${GIT_WORK_USER_NAME:?err}"
git config --file ~/.gitconfig-work user.email "${GIT_WORK_USER_EMAIL:?err}"

cat <<EOF >> ~/.gitconfig

[includeIf "hasconfig:remote.*.url:${GIT_PERSONAL_REMOTE:?err}:*/**"]
    path = ~/.gitconfig-personal

[includeIf "hasconfig:remote.*.url:${GIT_WORK_REMOTE:?err}:*/**"]
    path = ~/.gitconfig-work 
EOF

# ==========================================
# Setup kitty
# ==========================================

mkdir -p "${HOME}/.config/kitty/themes"

wget -qO \
  "${HOME}/.config/kitty/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/kitty/refs/heads/main/themes/mocha.conf

cp "configs/.config/kitty/kitty.conf" "${HOME}/.config/kitty"

kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "General" --key "TerminalApplication" "kitty"
kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "General" --key "TerminalService" "kitty.desktop"

echo '[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"' >> "${HOME}/.bashrc"

# ==========================================
# Setup lazygit
# ==========================================

mkdir "${HOME}/.config/lazygit"

wget -qO - https://raw.githubusercontent.com/catppuccin/lazygit/main/themes/mocha/mauve.yml \
  | yq eval '{"gui": .}' - > "${HOME}/.config/lazygit/config.yml"

# ==========================================
# Setup LibreOffice 
# ==========================================

mkdir -p "${HOME}/.config/libreoffice/4/user/config"

wget -qO \
  "${HOME}/.config/libreoffice/4/user/config/catppuccin-mocha-mauve.soc" \
  https://raw.githubusercontent.com/catppuccin/libreoffice/refs/heads/main/themes/mocha/mauve/catppuccin-mocha-mauve.soc

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
  wget -qO - https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/mocha/mauve/catppuccin-mocha-mauve.xcu
  echo '</oor:items>'
} > "${HOME}/.config/libreoffice/4/user/registrymodifications.xcu"

# ==========================================
# Setup mkcert
# ==========================================

mkcert -install

# ==========================================
# Setup neovim 
# ==========================================

sudo pacman  -Syu --needed --noconfirm lua luarocks

cp -r "configs/.config/nvim" "${HOME}/.config"

# ==========================================
# Setup NVIDIA Container Toolkit
# ==========================================

if command -v nvidia-ctk >/dev/null 2>&1; then
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
fi

# ==========================================
# Setup OBS Studio
# ==========================================
 
# https://github.com/catppuccin/obs

# ==========================================
# Setup Papirus icon theme
# ==========================================

wget -qO- https://git.io/papirus-folders-install | sh

kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "Icons" --key "Theme" "Papirus-Dark"

papirus-folders -C violet --theme Papirus-Dark

# ==========================================
# Setup qbittorrent
# ==========================================
 
# https://github.com/catppuccin/qbittorrent

# ==========================================
# Setup starship
# ==========================================

mkdir -p "${HOME}/.config/starship/themes"

wget -qO \
  "${HOME}/.config/starship/themes/mocha.conf" \
  https://raw.githubusercontent.com/catppuccin/starship/refs/heads/main/themes/mocha.toml

cp "configs/.config/starship/config.toml" "${HOME}/.config/starship/config.toml"

touch "${HOME}/.config/.starship.toml"

cat \
  "${HOME}/.config/starship/config.toml" \
  "${HOME}/.config/starship/themes/mocha.conf" \
  > "${HOME}/.config/.starship.toml"

echo 'eval "$(starship init bash)"' >> "${HOME}/.bashrc"

# ==========================================
# Setup superfile
# ==========================================

mkdir -p "${HOME}/.config/superfile/theme"

wget -qO \
  "${HOME}/.config/superfile/theme/catppuccin-mocha-mauve.toml" \
  https://raw.githubusercontent.com/catppuccin/superfile/refs/heads/main/themes/mocha/catppuccin-mocha-mauve.toml

cp "configs/.config/superfile/config.toml" "${HOME}/.config/superfile/config.toml"

# ==========================================
# Setup tdrop
# ==========================================

mkdir -p "${HOME}/.local/share/applications"

cp "configs/.local/share/applications/net.local.tdrop.desktop" "${HOME}/.local/share/applications/net.local.tdrop.desktop"

kwriteconfig6 --file "${HOME}/.config/kglobalshortcutsrc" --group "services" --group "net.local.tdrop.desktop" --key "_launch" "Alt+F12"

# ==========================================
# Setup Thunderbird  
# ==========================================

# https://github.com/catppuccin/thunderbird

# ==========================================
# Setup tmux
# ==========================================

mkdir -p "${HOME}/.config/tmux/plugins/catppuccin"

git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "${HOME}/.config/tmux/plugins/catppuccin/tmux"
git clone https://github.com/tmux-plugins/tmux-cpu "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-cpu"
git clone https://github.com/tmux-plugins/tmux-battery "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-battery"

cp "configs/.tmux.conf" "${HOME}/.tmux.conf"

# ==========================================
# Setup vim 
# ==========================================

mkdir -p "${HOME}/.vim/colors"

wget -qO \
  "${HOME}/.vim/colors/catppuccin_mocha.vim" \
  https://raw.githubusercontent.com/catppuccin/vim/refs/heads/main/colors/catppuccin_mocha.vim

cp "configs/.vimrc" "${HOME}/.vimrc"
