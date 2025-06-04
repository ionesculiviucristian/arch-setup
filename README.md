# Arch x64 setup

## Installation

```bash
cp .env.example .env
./install.sh
./install_hardware.sh
./install_aliases.sh
```

## Official Arch packages

- [Atuin](https://github.com/atuinsh/atuin): Magical shell history
- [base-devel](https://archlinux.org/packages/core/any/base-devel/): Basic tools to build Arch Linux packages
- [bash-completion](https://github.com/scop/bash-completion): Programmable completion functions for bash
- [bat](https://github.com/sharkdp/bat): A cat(1) clone with wings
- [ble.sh](https://github.com/akinomyoga/ble.sh): Bash Line Editor―a line editor written in pure Bash with syntax highlighting, auto suggestions, vim modes, etc. for Bash interactive sessions
- [Blender](https://www.blender.org/): The free and open source 3D creation suite
- [broot](https://dystroy.org/broot/): A new way to see and navigate directory trees
- [Btop++](https://github.com/aristocratos/btop): A monitor of resources
- [direnv](https://direnv.net/): direnv is an extension for your shell. It augments existing shells with a new feature that can load and unload environment variables depending on the current directory
- [DKMS](https://github.com/dell/dkms): Dynamic Kernel Modules System
- [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html): Provides network infrastructure for small networks: DNS, DHCP, router advertisement and network boot
- [Docker](https://www.docker.com/): An open platform for developing, shipping, and running applications
- [Docker Compose](https://github.com/docker/compose): Define and run multi-container applications with Docker
- [expac](https://github.com/falconindy/expac): alpm data extraction utility
- [eza](https://github.com/eza-community/eza): A modern alternative to ls
- [fastfetch](https://github.com/fastfetch-cli/fastfetch): A maintained, feature-rich and performance oriented, neofetch like system information tool
- [fd](https://github.com/sharkdp/fd): A simple, fast and user-friendly alternative to 'find'
- [Filezilla](https://filezilla-project.org/): The free FTP solution
- [Firefox](https://www.mozilla.org/en-US/firefox/): A free, Open Source web browser
- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder
- [Gimp](https://www.gimp.org/): The Free & Open Source Image Editor
- [git](https://git-scm.com/): A free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency
- [jq](https://github.com/jqlang/jq): Command-line JSON processor
- [KeePassXC](https://keepassxc.org/): Cross-platform Password Manager
- [kitty](https://sw.kovidgoyal.net/kitty/index.html): The fast, feature-rich, GPU based terminal emulator
- [kpackage](https://archlinux.org/packages/extra/x86_64/kpackage/): Framework that lets applications manage user installable packages of non-binary assets
- [Krita](https://krita.org/en/): A professional FREE and open source painting program
- [less](https://www.greenwoodsoftware.com/less/): Less is a free, open-source file pager
- [LibreOffice](https://www.libreoffice.org/): A private, free and open source office suite
- [Linux headers](https://archlinux.org/packages/core/x86_64/linux-headers/): Headers and scripts for building modules for the Linux kernel
- [Linux LTS headers](https://archlinux.org/packages/core/x86_64/linux-lts-headers/): Headers and scripts for building modules for the LTS Linux kernel
- [lsof](https://github.com/lsof-org/lsof): LiSt Open Files
- [mkcert](https://github.com/FiloSottile/mkcert): A simple zero-config tool to make locally trusted development certificates with any names you'd like
- [ncdu](https://dev.yorhel.nl/ncdu): Disk usage analyzer with an ncurses interface
- [neovim](https://neovim.io/): Hyperextensible Vim-based text editor
- [net-tools](https://sourceforge.net/projects/net-tools/): The collection of base networking utilities for Linux
- [Network Security Services (NSS)](https://firefox-source-docs.mozilla.org/security/nss/index.html): Network Security Services (NSS) is a set of libraries designed to support cross-platform development of security-enabled client and server applications
- [NTFS-3G](https://github.com/tuxera/ntfs-3g): NTFS-3G Safe Read/Write NTFS Driver
- [nvtop](https://github.com/Syllo/nvtop): GPU & Accelerator process monitoring for AMD, Apple, Huawei, Intel, NVIDIA and Qualcomm
- [OBS Studio](https://obsproject.com/): Free and open source software for video recording and live streaming
- [KDE Partition Manager](https://apps.kde.org/partitionmanager/): KDE Partition Manager is a utility to help you manage the disks, partitions, and file systems on your computer
- [qBittorrent](https://www.qbittorrent.org/): The qBittorrent project aims to provide an open-source software alternative to µTorrent
- [ripgrep](https://github.com/BurntSushi/ripgrep): ripgrep recursively searches directories for a regex pattern while respecting your gitignore
- [rsync](https://rsync.samba.org/): rsync is an open source utility that provides fast incremental file transfer
- [SMPlayer](https://www.smplayer.info/): Free Media Player with built-in codecs
- [solaar](https://pwr-solaar.github.io/Solaar/): Solaar is a Linux manager for many Logitech keyboards, mice, and trackpads that connect wirelessly to a USB Unifying, Bolt, Lightspeed, or Nano receiver
- [starship](https://starship.rs/): The minimal, blazing-fast, and infinitely customizable prompt for any shell!
- [superfile](https://superfile.netlify.app/): superfile is a very fancy and modern terminal file manager that can complete the file operations you need!!
- [Thunderbird](https://www.thunderbird.net/en-US/): The email and productivity app that maximizes your freedoms
- [tmux](https://github.com/tmux/tmux): tmux is a terminal multiplexer
- [tmuxp](https://tmuxp.git-pull.com/): Session manager for tmux, which allows users to save and load tmux sessions through simple configuration files
- [unzip](https://infozip.sourceforge.net/UnZip.html): UnZip is an extraction utility for archives compressed in .zip format (also called "zipfiles")
- [VirtualBox](https://www.virtualbox.org/): VirtualBox is a general-purpose full virtualization software for x86_64 hardware
- [VirtualBox Guest Additions ISO](https://archlinux.org/packages/extra/any/virtualbox-guest-iso/): Consist of device drivers and system applications that optimize the guest operating system for better performance and usability
- [VirtualBox Host DKMS](https://archlinux.org/packages/extra/x86_64/virtualbox-host-dkms/): VirtualBox Host kernel modules sources
- [zip](https://infozip.sourceforge.net/Zip.html): Zip is a compression and file packaging/archive utility
- [zoxide](https://github.com/ajeetdsouza/zoxide): A smarter cd command. Supports all major shells

## External packages

- [mgitstatus](https://github.com/fboender/multi-git-status): Show uncommitted, untracked and unpushed changes for multiple Git repos
- [Node Version Manager](https://github.com/nvm-sh/nvm): POSIX-compliant bash script to manage multiple active node.js versions
- [Poetry](https://python-poetry.org/): Python packaging and dependency management made easy
- [tdrop](https://github.com/noctuid/tdrop): A Glorified WM-Independent Dropdown Creator
- [Yay](https://github.com/Jguer/yay): Yet another Yogurt - An AUR Helper written in Go

## AUR packages

- [Brave](https://aur.archlinux.org/packages/brave-bin): The browser that puts you first
- [Postman](https://aur.archlinux.org/packages/postman-bin): Platform for building and using APIs management made easy
- [Spotify](https://aur.archlinux.org/packages/spotify): Online music streaming service
- [Visual Studio Code](https://aur.archlinux.org/packages/visual-studio-code-bin): Visual Studio Code combines the simplicity of a source code editor with powerful developer tooling, like IntelliSense code completion and debugging

## Hardware / misc

- [AMD microcode](https://gitlab.com/kernel-firmware/linux-firmware): Microcode update image for AMD CPUs
- [NVIDIA utils (32-bit)](https://archlinux.org/packages/multilib/x86_64/lib32-nvidia-utils/): NVIDIA drivers utilities (32-bit)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html): A collection of libraries and utilities enabling users to build and run GPU-accelerated containers
- [NVIDIA open DKMS](https://archlinux.org/packages/extra/x86_64/nvidia-open-dkms/): NVIDIA open kernel modules - module sources
- [NVIDIA settings](https://archlinux.org/packages/extra/x86_64/nvidia-settings/): Tool for configuring the NVIDIA graphics driver
- [NVIDIA utils](https://archlinux.org/packages/extra/x86_64/nvidia-utils/): NVIDIA drivers utilities

## Available aliases

For a list off all available aliases, [click here to view it](./ALIASES.md) or run `aliases` after installation

## Firefox plugins

- [Firefox Color](https://addons.mozilla.org/en-GB/firefox/addon/firefox-color/)
- [Catppuccin Mocha - Mauve](https://addons.mozilla.org/en-GB/firefox/addon/catppuccin-mocha-mauve-git)

## Brave plugins

- [Catppuccin Chrome Theme - Mocha](https://chromewebstore.google.com/detail/catppuccin-chrome-theme-m/bkkmolkhemgaeaeggcmfbghljjjoofoh)

## Additional notes

Install pre commit hooks

```bash
pip install pre-commit
pre-commit install
```
