# TUI installer

You are an expert Golang programmer with advanced knowledge in Arch Linux systems. Your task is to create a simple yet powerful TUI installer using Golang and `https://github.com/charmbracelet/bubbletea`, using the latest and best practices. You must use the latest versions of all libraries that are required in the project.

## Main features

The TUI installer allows the user to install packages and drivers based on profiles found in `./profiles`.

The installer will show the user what profiles they can install, defaulting to `Base` profile. It will also list available themes found in `./themes` directory.

When starting the actual installation, the TUI will use these rules to compile the install list:

- drivers are installed first
- packages are installed based on their priority ("highest" > "high" > "normal", so installs before the other)
- packages with `install: false` will be ignored
- non-aur packages will use pacman for installation using:

```bash
sudo pacman \
  -Syu \
  --needed \
  --noconfirm \
  ${pacman_packages}
```

- aur packages will use yay for installation using:

```bash
yay \
  -Syu \
  --needed \
  --noconfirm \
  ${pacman_packages}
```

- external packages will provide their own `install.sh` script, found in it's directory

- after all package installations, the TUI will config them, using a `setup.sh` script, found in their directories

- after the config has finished, the TUI will setup themes, using a `setup_theme.sh` script, found in their directories

The TUI can receive the following args:

- `--profile`: path to a custom profile to be loaded in the profiles list, checked by default
