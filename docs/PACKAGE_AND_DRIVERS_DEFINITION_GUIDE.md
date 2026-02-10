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

- `description`: should use the package's official webpage description if available or fallback to that of the source code's webpage
- `source_url`: if there is no official source of the package then building source from `https://gitlab.archlinux.org/` should be used
- `url`: if the package has no official URL then it will be set to `null`

### `setup.sh` mandatory workflow

- scripts will use `set -eu` running mode
- any comment references to external URLs must be put after `set -eu` using a new line; this is usually for referencing configs, shell integrations etc.:

```bash
set -eu

# [config] https://url/to/package/config/docs
# [Default config] https://url/to/package/default/config/file
# [shell] https://url/to/package/shell/integration/docs

```

- `root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"` is always defined and used when copying files from the packages's folder (mostly for config files)
- always make sure the package's required directories are created before:

```bash
package_dir="${HOME}/.config/package"
mkdir -p "${package_dir}"
```

- `"${root_dir}/scripts/update_bashrc.sh"` is used last if any shell integration is need it
- scripts will use the redundant `exit 0` when finished
