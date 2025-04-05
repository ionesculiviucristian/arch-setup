# Arch x64 setup

## Installation

```bash
cp .env.example .env
./install.sh
./install_hardware.sh
./install_aliases.sh
```

After system reboot

```bash
./post_reboot.sh
```

## Official Arch packages

- [Alacritty](https://alacritty.org/): Alacritty is a modern terminal emulator that comes with sensible defaults, but allows for extensive configuration
- [Atuin](https://github.com/atuinsh/atuin): Magical shell history
- [bat](https://github.com/sharkdp/bat): A cat(1) clone with wings
- [Blender](https://www.blender.org/): The free and open source 3D creation suite
- [Brave](https://brave.com/): The browser that puts you first
- [Btop++](https://github.com/aristocratos/btop): A monitor of resources
- [Visual Studio Code](https://code.visualstudio.com/): Visual Studio Code combines the simplicity of a source code editor with powerful developer tooling, like IntelliSense code completion and debugging
- [DKMS](https://github.com/dell/dkms): Dynamic Kernel Modules System
- [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html): Provides network infrastructure for small networks: DNS, DHCP, router advertisement and network boot
- [Docker](https://www.docker.com/): An open platform for developing, shipping, and running applications
- [Docker Compose](https://github.com/docker/compose): Define and run multi-container applications with Docker
- [eza](https://github.com/eza-community/eza): A modern alternative to ls
- [fastfetch](https://github.com/fastfetch-cli/fastfetch): A maintained, feature-rich and performance oriented, neofetch like system information tool
- [fd](https://github.com/sharkdp/fd): A simple, fast and user-friendly alternative to 'find'
- [Filezilla](https://filezilla-project.org/): The free FTP solution
- [Firefox](https://www.mozilla.org/en-US/firefox/): A free, Open Source web browser
- [Flatpak](https://flatpak.org/): The future of apps on Linux
- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder
- [Gimp](https://www.gimp.org/): The Free & Open Source Image Editor
- [git](https://git-scm.com/): A free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency
- [jq](https://github.com/jqlang/jq): Command-line JSON processor
- [KeePassXC](https://keepassxc.org/): Cross-platform Password Manager
- [Krita](https://krita.org/en/): A professional FREE and open source painting program
- [LibreOffice](https://www.libreoffice.org/): A private, free and open source office suite
- [Linux headers](https://archlinux.org/packages/core/x86_64/linux-headers/): Headers and scripts for building modules for the Linux kernel
- [Linux LTS headers](https://archlinux.org/packages/core/x86_64/linux-lts-headers/): Headers and scripts for building modules for the LTS Linux kernel
- [lsof](https://github.com/lsof-org/lsof): LiSt Open Files
- [ncdu](https://dev.yorhel.nl/ncdu): Disk usage analyzer with an ncurses interface
- [neovim](https://neovim.io/): Hyperextensible Vim-based text editor
- [net-tools](https://sourceforge.net/projects/net-tools/): The collection of base networking utilities for Linux
- [nvtop](https://github.com/Syllo/nvtop): GPU & Accelerator process monitoring for AMD, Apple, Huawei, Intel, NVIDIA and Qualcomm
- [OBS Studio](https://obsproject.com/): Free and open source software for video recording and live streaming
- [qBittorrent](https://www.qbittorrent.org/): The qBittorrent project aims to provide an open-source software alternative to µTorrent
- [rsync](https://rsync.samba.org/): rsync is an open source utility that provides fast incremental file transfer
- [SMPlayer](https://www.smplayer.info/): Free Media Player with built-in codecs
- [starship](https://starship.rs/): The minimal, blazing-fast, and infinitely customizable prompt for any shell!
- [Thunderbird](https://www.thunderbird.net/en-US/): The email and productivity app that maximizes your freedoms
- [tmux](https://github.com/tmux/tmux): tmux is a terminal multiplexer
- [tree](https://gitlab.com/OldManProgrammer/unix-tree): A handy little utility to display a tree view of directories
- [unzip](https://infozip.sourceforge.net/UnZip.html): UnZip is an extraction utility for archives compressed in .zip format (also called "zipfiles")
- [VirtualBox](https://www.virtualbox.org/): VirtualBox is a general-purpose full virtualization software for x86_64 hardware
- [VirtualBox Guest Additions ISO](https://archlinux.org/packages/extra/any/virtualbox-guest-iso/): Consist of device drivers and system applications that optimize the guest operating system for better performance and usability
- [VirtualBox Host DKMS](https://archlinux.org/packages/extra/x86_64/virtualbox-host-dkms/): VirtualBox Host kernel modules sources
- [zoxide](https://github.com/ajeetdsouza/zoxide): A smarter cd command. Supports all major shells

## External packages

- [mgitstatus](https://github.com/fboender/multi-git-status): Show uncommitted, untracked and unpushed changes for multiple Git repos
- [Node Version Manager](https://github.com/nvm-sh/nvm): POSIX-compliant bash script to manage multiple active node.js versions
- [Poetry](https://python-poetry.org/): Python packaging and dependency management made easy

## Flatpack packages

- [Spotify](https://flathub.org/apps/com.spotify.Client): Online music streaming service
- [Postman](https://flathub.org/apps/com.getpostman.Postman): Platform for building and using APIs management made easy

## Hardware / misc

- [AMD microcode](https://gitlab.com/kernel-firmware/linux-firmware): Microcode update image for AMD CPUs
- [NVIDIA utils (32-bit)](https://archlinux.org/packages/multilib/x86_64/lib32-nvidia-utils/): NVIDIA drivers utilities (32-bit)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html): A collection of libraries and utilities enabling users to build and run GPU-accelerated containers
- [NVIDIA open DKMS](https://archlinux.org/packages/extra/x86_64/nvidia-open-dkms/): NVIDIA open kernel modules - module sources
- [NVIDIA settings](https://archlinux.org/packages/extra/x86_64/nvidia-settings/): Tool for configuring the NVIDIA graphics driver
- [NVIDIA utils](https://archlinux.org/packages/extra/x86_64/nvidia-utils/): NVIDIA drivers utilities
- [Steam](https://store.steampowered.com/): The ultimate destination for playing, discussing, and creating games

## Available aliases

For a list off all available aliases, click [here](./ALIASES.md) or run `aliases` after installation

## Additional notes

Install pre commit hooks

```bash
pip install pre-commit
pre-commit install
```
