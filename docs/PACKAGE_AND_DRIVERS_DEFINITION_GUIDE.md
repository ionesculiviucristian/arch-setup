# Package and drivers definition guide

Packages are stored in `./repositories/packages` folder.
Drivers are stored in `./repositories/drivers` folder.
They both follow the same rules of definition.

## Package folder structure

```bash
repositories/packages/package
├── config/ # contains package configuration files
├── install.sh # install script for a package (usually present for external packages)
├── package.yml # contains package metadata
├── setup_secrets.sh # setup any secrets used by the package
├── setup_theme.sh # setup script for the package's theme
└── setup.sh # setup script after a package is installed
```

### `package.yml` metadata definition

```yaml
description: "" # Package's description
label: "" # Package's label
name: "" # Package's name used by pacman or yay during installation
repository: "" # Repository type from the arch repository website; possible values are: "core", "extra", "multilib", "aur", "external"
repository_url: "" # Package's URL from the arch repository website
source_url: "" # Package's source code URL
url: "" # Package's official webpage URL
```

- `description`: taken from the first source where it is found, in this order: the package's official webpage, the source code repository's description, the arch repository's description
- `repository_url`: uses the package's real architecture from the arch repository website (`x86_64` or `any`); if the package is not in an arch repository then it will be set to `null`
- `source_url`: the real upstream source code (not a mirror); if the package has no official source code then it will be set to `null`
- `url`: the package's own official webpage; if the package has no official webpage (only a source code repository) then it will be set to `null`

### `setup.sh` mandatory workflow

- scripts will use `set -eu` running mode
- any comment references to external URLs must be put after `set -eu` using a new line; this is usually for referencing configs, shell integrations etc.:

```bash
set -eu

# [config] https://url/to/package/config/docs
# [Default config] https://url/to/package/default/config/file
# [shell] https://url/to/package/shell/integration/docs

```

- `package_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"` is always defined and used for files from the package's own folder (mostly config files)
- `root_dir="${package_dir%/repositories/*}"` is defined only when the script needs files outside the package (`scripts/`, `.env`, `mounts.json`)
- always make sure the package's required directories are created before:

```bash
package_dir="${HOME}/.config/package"
mkdir -p "${package_dir}"
```

- shell integration goes in `bashrc.sh` at the package's root and is installed last with `scripts/setup_shell.sh` (the last argument is the file; omit it and pipe stdin for dynamic content), which writes `~/.bashrc.d/<priority>-<name>.sh`:

```bash
"${root_dir}/scripts/setup_shell.sh" \
  --package "package" \
  --priority "50" \
  "${package_dir}/bashrc.sh"
```

  - priorities: `10` bash, `20` env / PATH, `50` tool integrations, `80` atuin, `90` prompt, `99` ble.sh attach
- scripts will use the redundant `exit 0` when finished
