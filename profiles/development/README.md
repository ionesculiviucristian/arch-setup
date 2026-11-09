# Development

Installed with `./install.sh development`, which installs [base](../base/README.md) first.

## Official Arch packages

- [Bash Language Server](https://github.com/bash-lsp/bash-language-server/): Bash language server implementation based on Tree Sitter and its grammar for Bash
  - Optional dependencies:
    - [bash-completion](https://github.com/scop/bash-completion/): for CLI args completion
    - [man-db](https://man-db.nongnu.org/): for documentation via manual pages
    - [sh](https://pkg.go.dev/mvdan.cc/sh/v3): for formatting support
    - [ShellCheck](https://www.shellcheck.net/): for linting support
- [buildx](https://www.docker.com/) \[[source](https://github.com/docker/buildx/)\]: Docker CLI plugin for extended build capabilities with BuildKit
- [direnv](https://direnv.net/) \[[source](https://github.com/direnv/direnv/)\]: A shell extension that manages your environment
- [Docker](https://www.docker.com/) \[[source](https://github.com/docker/cli/)\]: Pack, ship and run any application as a lightweight container
  - Optional dependencies:
    - [BTRFS tools](https://btrfs.readthedocs.io/en/latest/): btrfs backend support
    - [buildx](https://www.docker.com/): extended build capabilities
    - [pigz](https://www.zlib.net/pigz/): parallel gzip compressor support
- [Docker Compose](https://www.docker.com/) \[[source](https://github.com/docker/compose/)\]: Fast, isolated development environments using Docker
- [FileZilla](https://filezilla-project.org/) \[[source](https://svn.filezilla-project.org/svn/FileZilla3/trunk/)\]: Fast and reliable FTP, FTPS and SFTP client
- [GitHub CLI](https://cli.github.com/) \[[source](https://github.com/cli/cli/)\]: The GitHub CLI
  - Optional dependencies:
    - [git](https://git-scm.com/): To interact with repositories
- [Go](https://go.dev/) \[[source](https://github.com/golang/go/)\]: Core compiler tools for the Go programming language
- [lazygit](https://github.com/jesseduffield/lazygit/): Simple terminal UI for git commands
- [mise](https://mise.jdx.dev/) \[[source](https://github.com/jdx/mise/)\]: The front-end to your dev env
  - Optional dependencies:
    - [bash-completion](https://github.com/scop/bash-completion/): bash completion support
- [neovim](https://neovim.io/) \[[source](https://github.com/neovim/neovim/)\]: Fork of Vim aiming to improve user experience, plugins, and GUIs
  - Optional dependencies:
    - [wl-clipboard](https://github.com/bugaevc/wl-clipboard/): for clipboard support on wayland (see :help clipboard)
- [pnpm](https://pnpm.io/) \[[source](https://github.com/pnpm/pnpm/)\]: Fast, disk space efficient package manager
- [sh](https://pkg.go.dev/mvdan.cc/sh/v3) \[[source](https://github.com/mvdan/sh/)\]: Format shell programs
- [ShellCheck](https://www.shellcheck.net/) \[[source](https://github.com/koalaman/shellcheck/)\]: Shell script analysis tool
- [shtab](https://tqdm.github.io/shtab/) \[[source](https://github.com/tqdm/shtab/)\]: Automagic shell tab completion for Python CLI applications
- [tmuxp](https://tmuxp.git-pull.com/) \[[source](https://github.com/tmux-python/tmuxp/)\]: Tmux session manager built on libtmux
  - Optional dependencies:
    - [shtab](https://tqdm.github.io/shtab/): for workspace completion and import
- [uv](https://docs.astral.sh/uv/) \[[source](https://github.com/astral-sh/uv/)\]: An extremely fast Python package installer and resolver written in Rust

## AUR packages

- [gita](https://github.com/nosarthur/gita/): Command-line tool to manage multiple git repos
- [Postman](https://www.postman.com/product/): Build, test, and document your APIs faster
- [Visual Studio Code](https://code.visualstudio.com/) \[[source](https://github.com/microsoft/vscode/)\]: Visual Studio Code (vscode): Editor for building and debugging modern web and cloud applications (official binary version)
