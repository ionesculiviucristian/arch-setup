# Aliases

## File system

- `..`: Go up a directory level
- `...`: Go up two directory levels
- `....`: Go up three directory levels
- `.....`: Go up four directory levels
- `.1`: Go up a directory level
- `.2`: Go up two directory levels
- `.3`: Go up three directory levels
- `.4`: Go up four directory levels
- `files`: Show a sorted list of file and folder sizes
- `ll`: Show a detailed list of all files and folders
- `space`: Show disk space for all filesystems
- `tree`: Print out a directory structure in a tree-like

## Packages manager

- `pkgi <PACKAGE...>`: Install packages
- `pkgr <PACKAGE...>`: Remove packages
- `pkgu`: Update packages

## Docker

- `dex <CONTAINER> [COMMAND] {sh}`: Execute a command in a running container
- `dexenv <CONTAINER> [COMMAND] {sh}`: Execute printenv in a running container
- `dexr <CONTAINER> [COMMAND] {sh}`: Execute a command in a running container, as root
- `di <NAME|ID>`: Return low-level information on Docker objects
- `dimls`: List images
- `dimlsa`: List all docker images
- `dimlsf <PATTERN>`: Filter docker images
- `dl <CONTAINER>`: Fetch the logs of a container
- `dlclr`: Empty the log files from all containers
- `dlsz`: List all container log files ordered by their size
- `dps`: List running containers
- `dpsa`: List all containers
- `dpsaf <PATTERN>`: Filter all containers list using grep pattern
- `dpsf <PATTERN>`: Filter running containers list using grep pattern
- `ds <CONTAINER...>`: Stop one or more running containers
- `dsa`: Stop all running containers

## Docker compose

- `dc`: Define and run multi-container applications with Docker
- `dcb <SERVICE...>`: Build or rebuild services
- `dcd <SERVICE...>`: Stop and remove containers, networks
- `dcdv <SERVICE...>`: Stop and remove containers, networks including volumes
- `dcex <SERVICE> [COMMAND] {sh}`: Execute a command in a running container
- `dcexenv <SERVICE> [COMMAND] {sh}`: Execute printenv in a running container
- `dcexr <SERVICE> [COMMAND] {sh}`: Execute a command in a running container, as root
- `dci <SERVICE>`: Return low-level information on Docker objects
- `dcl <SERVICE...>`: View output from containers
- `dcps <SERVICE...>`: List containers
- `dcpsf <SERVICE>`: Filter running containers list using grep pattern
- `dcr <SERVICE...>`: Restart service containers
- `dcrl <SERVICE...>`: Restart service containers and view output from containers
- `dcu <SERVICE...>`: Create and start containers
- `dcub <SERVICE...>`: Build, create and start containers
- `dcuf <SERVICE...>`: Recreate and start containers even if their configuration and image haven't changed
- `dcul <SERVICE...>`: Create, start and view output from containers

## git

- `gib`: List branches
- `gibc <NAME>`: Create branch
- `gibco <NAME>`: Create and checkout branch
- `gibd <BRANCH>`: Delete merged branch
- `gibdf <BRANCH>`: Delete non-merged branch
- `gibr <OLD BRANCH> <NEW BRANCH>`: Rename branch
- `gic [MESSAGE] {WIP}`: Stage and commit all files from current directory
- `gica [MESSAGE] {WIP}`: Amend commit
- `gico <BRANCH>`: Checkout branch
- `gicpu [MESSAGE] {WIP}`: Stage, commit and push all files from current directory
- `gicpuf [MESSAGE] {WIP}`: Stage, commit and force push with lease all files from current directory
- `gif`: Download objects and refs from another repository
- `gil`: Show commit logs
- `gim <BRANCH...>`: Join two or more development histories together
- `gip`: Fetch from and integrate with another repository or a local branch
- `gipr`: Fetch from and integrate with another repository or a local branch using rebase
- `gipu`: Update remote refs along with associated objects
- `gipuf`: Force update with lease remote refs along with associated objects
- `girh <SHA1>`: Hard reset current HEAD to the specified state
- `gis`: Stash the changes in a dirty working directory away
- `gisp`: Remove a single stashed state from the stash list and apply it on top of the current working tree state
- `gisq <SHA1> <MESSAGE>`: Squash commits
- `gisqa <MESSAGE>`: Squashes ALL commits of the current branch

## poetry

- `poi`: Install project dependencies
- `pos`: Spawn a shell within the virtual environment

## Projects

- `proj`: Set the current working directory to `~/Projects`
- `projc <NAME>`: Create a new project in `~/Projects`
- `projo <NAME>`: Open a project found in `~/Projects` with code editor

## Misc

- `backup`: Backup files from current directory to `~/Backups`
- `logs`: Tail all journal entries
- `logsb`: View all journal entries since last boot
- `ports`: Lists listening TCP/UDP sockets
- `portsf <PORT>`: Filter listening TCP/UDP sockets
- `src`: Source `~/.bashrc`
