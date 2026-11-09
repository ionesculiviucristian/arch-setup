# AGENTS.md

Arch Linux workstation setup: profiles list packages and drivers, each with its own scripts.

## Layout

- `install.sh [profile] [phases...] [--themes]` runs `profiles/<profile>/install.sh` (default `base`); every profile installer takes the phases `packages`, `external`, `aur`, `setups`, `themes` (base also `pre`, `resources`); every installer starts with `installer::start`, which records this folder in `~/.local/state/arch-setup/dir` for the repositories installed on top and the repository being installed in `~/.local/state/arch-setup/repositories`, read back by `lib/index.sh`, and ends with `installer::finish` (`lib/installer.sh`); `update.sh [profile] [--themes]` updates the packages, the fonts and runs the `update.sh` of every installed package and of the given profile's own package folders (default `base`); themes are applied only with `--themes` (or the `themes` phase)
- `profiles/<name>/profile.yml` (`packages:`, `drivers:`) and `profiles/<name>/install.sh`; `base` is installed on every machine, machine profiles go on top
- `profiles/<name>/packages/<package>/` holds the machine-specific scripts of a package (`setup.sh`, `config/`), run by `profile::run_scripts` after the ones of the profile's own entries; the package keeps its `package.yml` in `repositories/`, and the target does not have to belong to this profile, so a `base` package is tuned here instead of in the shared definition
- `repositories/{packages,drivers}/<name>/`: `package.yml`, `setup.sh`, `setup-theme.sh`, `install.sh` (bootstrap of packages that pacman/yay cannot install, e.g. yay), `update.sh` (updates what pacman/yay do not: plugins, language tools), `bashrc.sh`, `config/`; these stay machine-neutral
- `repositories/fonts/*.yml`, `repositories/requirements/*.yml` (file name is the pacman name, read before `yq` exists)
- `lib/` shared functions, `os/` system setup (`config/`, `media/`), `themes/*.yml`, `schemas/` (JSON schemas for every yml)
- generated, never edited by hand: `README.md` and `profiles/<name>/README.md` (`scripts/generate-readme.js`, `docs/readme/`) and `.bash_aliases_help` (`scripts/generate_bash_aliases_help.py`); the husky pre-commit hook regenerates them

## Definitions

- profile entries only set non-default values: `priority` (`"highest"`, `"high"`, default `"normal"`; orders the install and setup scripts), `themes` (default `false`)
- `package.yml` keys keep the schema order: `label`, `description`, `url`, `source.url`, `source.release_asset` or `source.release_asset_pattern`, `repository.url`, `repository.optional_dependency_for`
- `description` is copied from `pacman -Si`/`-Qi` or the AUR, without packaging notes
- `url` is the official webpage, `source.url` the real upstream; `null` when missing
- `repository.url` is the archlinux.org or AUR page, `null` for external packages; repository type (`core`, `extra`, `multilib`, `aur`, `external`) and pacman name are derived from it
- `optional_dependency_for` is documentation only; `reason` is copied from the parent's optdeps

## Scripts

- `#!/bin/bash`, `set -eu`, end with `exit 0`; references go after `set -eu` as `# @see [config](url)` with generic labels (`config`, `shell`, `theme`, `wiki`)
- `package_dir` is always defined; `root_dir="${package_dir%/repositories/*}"` only when files outside the package are needed; `lib/` is loaded with `source "${root_dir}/lib/index.sh"` and a `# shellcheck source=` directive
- static config files live in `config/`, never in heredocs; copy files with `install -D -m 644` (`-m 755` for executables, `sudo` for system paths); `cp -r` only for directories, `mkdir -p` only before downloads or clones
- text substitutions use `file::replace_text`, shell integration uses `bash::install_bashrc` (priorities: `10` bash, `20` env/PATH, `50` tools, `80` atuin, `90` prompt, `99` ble.sh)
- `setup-theme.sh` receives `<flavour> <accent>` and reads anything else with `theme::get`
- units and timers that a package ships disabled are enabled in its `setup.sh`; machine fixes (kernel modules, journald limits) are provisioned the same way, never by hand
- long CLI flags in `.bash_aliases` and `bashrc.sh` files

## `lib/`

- one file per domain, functions named `<file>::<function>`; internal ones are `<file>::_<function>` and marked `@internal`
- shdoc comments: `@description`, `@arg`/`@option`/`@stdin`, `@exitcode` only for real errors; comment lines wrap at 80 characters
- public functions print `Usage: ...` with `log::error` and return `2` on missing or wrong arguments, return `1` on errors, never `exit`
- no unused functions and no functions called from a single place
- functions use `arch_setup_dir` (set by `lib/index.sh`), never the caller's `root_dir`; the definitions, the profiles and the files a repository owns (`.env`, `mounts.json`) are looked up in every root of `arch_setup_dirs` (`package::_dir`, `profile::_file`, `file::find`), so a repository installed on top of this one, like arch-setup-private, prepends itself and keeps using the same `lib/`

## Verification

- `shellcheck -x`, `shfmt -d -i 2` and `bash -n` on every changed `.sh` file
- `node scripts/validate-schemas.js` and `node scripts/generate-readme.js` after changing definitions, profiles or templates
- commits follow Conventional Commits (commitlint) and carry no AI co-author trailers
