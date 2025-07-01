#!/bin/bash
set -eu

PASSWORDLESS_SUDO="/etc/sudoers.d/$(whoami)"

echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "${PASSWORDLESS_SUDO}"

# ==========================================
# Create directories
# ==========================================

cp "./configs/.bashrc" "${HOME}/.bashrc"

mkdir -p "${HOME}/.bash_aliases.d"
mkdir -p "${HOME}/.local/share/fonts"
mkdir -p "${HOME}/.repos"
mkdir -p "${HOME}/Backups/docker"
mkdir -p "${HOME}/Pictures/Wallpapers"
mkdir -p "${HOME}/Projects"

./scripts/add_places_entry.sh "${HOME}/Backups" "Backups"
./scripts/add_places_entry.sh "${HOME}/Projects" "Projects"

# ==========================================
# Install packages
# ==========================================

# shellcheck disable=SC2046
sudo pacman -Syu --needed --noconfirm $(<"./data/lists/official.txt")

# ==========================================
# Install yay
# ==========================================

./installers/yay.sh

# ==========================================
# Install AUR packages
# ==========================================

# shellcheck disable=SC2046
yay -Syu --needed --noconfirm $(<"./data/lists/aur.txt")

# ==========================================
# Install fonts
# ==========================================

./scripts/install_font.sh https://github.com/eigilnikolajsen/commit-mono/releases/download/v1.143/CommitMono-1.143.zip
./scripts/install_font.sh https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz

# ==========================================
# Install themes
# ==========================================

./scripts/install_themes.sh

# ==========================================
# Install external packages
# ==========================================

./installers/ble.sh.sh
./installers/multi-git-status.sh
./installers/nvm.sh
./installers/poetry.sh
./installers/pyenv.sh

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

cp "./configs/.local/share/konsole/Starship.profile" "${HOME}/.local/share/konsole"

kwriteconfig6 --file "${HOME}/.config/konsolerc" --group "Desktop Entry" --key "DefaultProfile" "Starship.profile"

# ==========================================
# Setup Night Color
# ==========================================

kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "Active" --type "bool" true
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "DayTemperature" 5700
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "LatitudeFixed" 45.65
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "LongitudeFixed" 25.63
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "Mode" "Location"
kwriteconfig6 --file "${HOME}/.config/kwinrc" --group "NightColor" --key "NightTemperature" 3500

# ==========================================
# Setup SDDM 
# ==========================================

sudo mkdir -p "/etc/sddm.conf.d"

sudo cp "./configs/etc/sddm.conf.d/kde_settings.conf" "/etc/sddm.conf.d/kde_settings.conf"

# ==========================================
# Setup atuin
# ==========================================

mkdir -p "${HOME}/.config/atuin"

cp "./configs/.config/atuin/config.toml" "${HOME}/.config/atuin/config.toml"

echo 'eval "$(atuin init bash)"' >> "${HOME}/.bashrc"

# ==========================================
# Setup bat
# ==========================================

mkdir -p "${HOME}/.config/bat"

cp "./configs/.config/bat/config" "${HOME}/.config/bat/config"

# ==========================================
# Setup Bitwarden
# ==========================================

echo 'export SSH_AUTH_SOCK="${HOME}/.bitwarden-ssh-agent.sock"' >> "${HOME}/.bashrc"

# ==========================================
# Setup btop
# ==========================================

mkdir -p "${HOME}/.config/btop"

cp "./configs/.config/btop/btop.conf" "${HOME}/.config/btop/btop.conf"

# ==========================================
# Setup direnv
# ==========================================

echo 'eval "$(direnv hook bash)"' >> "${HOME}/.bashrc"

# ==========================================
# Setup docker
# ==========================================

sudo mkdir -p "/etc/docker"

sudo cp "./configs/etc/docker/daemon.json" "/etc/docker/daemon.json"

sudo systemctl start docker.service
sudo systemctl enable docker.service

sudo usermod -aG docker "${USER}"

# ==========================================
# Setup kitty
# ==========================================

mkdir -p "${HOME}/.config/kitty"

cp "./configs/.config/kitty/kitty.conf" "${HOME}/.config/kitty"

kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "General" --key "TerminalApplication" "kitty"
kwriteconfig6 --file "${HOME}/.config/kdeglobals" --group "General" --key "TerminalService" "kitty.desktop"

echo '[ "${TERM}" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"' >> "${HOME}/.bashrc"

# ==========================================
# Setup mkcert
# ==========================================

mkcert -install

# ==========================================
# Setup neovim 
# ==========================================

sudo pacman -Syu --needed --noconfirm luarocks

cp -r "./configs/.config/nvim" "${HOME}/.config"

# ==========================================
# Setup NVIDIA Container Toolkit
# ==========================================

if command -v nvidia-ctk >/dev/null 2>&1; then
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
fi

# ==========================================
# Setup proftpd
# ==========================================

sudo cp "./configs/etc/proftpd.conf" "/etc/proftpd.conf"

echo "127.0.0.1 ftp.localdev" | sudo tee -a "/etc/hosts"

sudo iptables -I INPUT 1 -p tcp -s 127.0.0.1 --dport 21 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 21 -j DROP

sudo systemctl enable proftpd.service
sudo systemctl start proftpd.service

# ==========================================
# Setup starship
# ==========================================

mkdir -p "${HOME}/.config/starship"

cp "./configs/.config/starship/config.toml" "${HOME}/.config/starship/config.toml"

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

cp "./configs/.config/superfile/config.toml" "${HOME}/.config/superfile/config.toml"

# ==========================================
# Setup tdrop
# ==========================================

mkdir -p "${HOME}/.local/share/applications"

cp "./configs/.local/share/applications/net.local.tdrop.desktop" "${HOME}/.local/share/applications/net.local.tdrop.desktop"

kwriteconfig6 --file "${HOME}/.config/kglobalshortcutsrc" --group "services" --group "net.local.tdrop.desktop" --key "_launch" "Alt+F12"

# ==========================================
# Setup tmux
# ==========================================

mkdir -p "${HOME}/.config/tmux/plugins//tmux-plugins"

git clone https://github.com/tmux-plugins/tmux-cpu "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-cpu"
git clone https://github.com/tmux-plugins/tmux-battery "${HOME}/.config/tmux/plugins/tmux-plugins/tmux-battery"

cp "./configs/.tmux.conf" "${HOME}/.tmux.conf"

# ==========================================
# Setup vim 
# ==========================================

cp "./configs/.vimrc" "${HOME}/.vimrc"

# ==========================================
# Post install
# ==========================================

./scripts/install_aliases.sh

sudo rm "${PASSWORDLESS_SUDO}"
