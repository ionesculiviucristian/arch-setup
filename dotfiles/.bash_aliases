# ======================================
# File system
# ======================================

# @info Go up a directory level
# @group files
alias ..="cd ../"

# @info Go up two directory levels
# @group files
alias ...="cd ../../"

# @info Go up three directory levels
# @group files
alias ....="cd ../../../"

# @info Go up four directory levels
# @group files
alias .....="cd ../../../../"

# @info Go up a directory level
# @group files
alias .1="cd ../"

# @info Go up two directory levels
# @group files
alias .2="cd ../../"

# @info Go up three directory levels
# @group files
alias .3="cd ../../../"

# @info Go up four directory levels
# @group files
alias .4="cd ../../../../"

# @info Show a sorted list of file and folder sizes
# @group files
function files() {
    du --all --total --human-readable "$@" | sort --human-numeric-sort
}

# @info Show a detailed list of all files and folders
# @group files
alias ll="eza --long --all --group --group-directories-first --git"

# @info Show disk space for all filesystems
# @group files
alias space="df --print-type --human-readable --all --total"

# @info Print out a directory structure in a tree-like
# @group files
alias tree="eza --tree"

# ======================================
# Package manager
# ======================================

if command -v apt > /dev/null; then
    PACKAGE_MANAGER="apt"
elif command -v pacman > /dev/null; then
    PACKAGE_MANAGER="pacman"
elif command -v zypper > /dev/null; then
    PACKAGE_MANAGER="zypper"
else
    PACKAGE_MANAGER="" 
fi

# @info Install packages
# @group pkgmgr
# @param <PACKAGE...>
function pkgi() {
    case "$PACKAGE_MANAGER" in
        apt)
             sudo apt update && sudo apt install "$@"
            ;;
        pacman)
            sudo pacman -Sy "$@"
            ;;
        zypper)
            sudo zypper refresh && sudo zypper install "$@"
            ;;
        *)
            echo "Unsupported package manager"
            ;;
    esac
}

# @info Remove packages
# @group pkgmgr
# @param <PACKAGE...>
function pkgr() {
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt purge "$@" && sudo apt autoremove
            ;;
        pacman)
            sudo pacman -Rns "$@" && sudo pacman -Qtdq | sudo pacman -Rns -
            ;;
        zypper)
            sudo zypper remove "$@" && sudo zypper clean --all
            ;;
        *)
            echo "Unsupported package manager"
            ;;
    esac
}

# @info Update packages
# @group pkgmgr
function pkgu() {
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt update && sudo apt upgrade
            ;;
        pacman)
            sudo pacman -Syu
            ;;
        zypper)
            sudo zypper refresh && sudo zypper update
            ;;
        *)
            echo "Unsupported package manager"
            ;;
    esac
}

# ======================================
# Docker
# ======================================

_complete_containers() {
    local MODE="$1"
    if [[ ${MODE} == "single" ]]; then
        shift
    fi
    if [[ ${MODE} == "single" && ${COMP_CWORD} -ge 2 ]]; then
        COMPREPLY=()
        return 0
    fi
    local CONTAINERS=$(docker ps --format "{{.Names}}")
    COMPREPLY=($(compgen -W "${CONTAINERS}}" -- "$2"))
}

_complete_container() {
    _complete_containers "single" "$@"
}

# @info Execute a command in a running container
# @group docker
# @param <CONTAINER>
# @param [COMMAND] {sh}
function dex() {
    docker exec -it "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_container de

# @info Execute printenv in a running container
# @group docker
# @param <CONTAINER>
# @param [COMMAND] {sh}
function dexenv() {
    docker exec "$1" printenv
}
complete -o nospace -F _complete_container de

# @info Execute a command in a running container, as root
# @group docker
# @param <CONTAINER>
# @param [COMMAND] {sh}
function dexr() {
    docker exec -it --user root "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_container der

# @info Return low-level information on Docker objects
# @group docker
# @param <NAME|ID>
function di() {
    docker inspect "$1"
}
complete -o nospace -F _complete_container di

# @info List images
# @group docker
function dimls() {
    docker image ls
}

# @info List all docker images
# @group docker
function dimlsa() {
    docker image ls --all
}

# @info Filter docker images
# @group docker
# @param <PATTERN>
function dimlsf() {
    docker image ls | grep "$1"
}

# @info Fetch the logs of a container
# @group docker
# @param <CONTAINER>
function dl() {
    docker logs --follow "$1"
}
complete -o nospace -F _complete_container dl

# @info Empty the log files from all containers
# @group docker
alias dlclr='docker ps -aq | xargs --replace={} sh -c "sudo truncate --size=0 \$(docker inspect --format=\"{{.LogPath}}\" {})"'

# @info List all container log files ordered by their size
# @group docker
alias dlsz='sudo du -ch $(docker inspect --format="{{.LogPath}}" $(docker ps --all --quiet)) | sort -h'

# @info List running containers
# @group docker
alias dps="docker ps"

# @info List all containers
# @group docker
alias dpsa="docker ps --all"

# @info Filter running containers list using grep pattern
# @group docker
# @param <PATTERN>
function dpsf() {
    docker ps | grep "$1"
}

# @info Filter all containers list using grep pattern
# @group docker
# @param <PATTERN>
function dpsaf() {
    docker ps --all | grep "$1"
}

# @info Stop one or more running containers
# @group docker
# @param <CONTAINER...>
function ds() {
    docker stop "$@"
}
complete -F _complete_containers ds

# @info Stop all running containers
# @group docker
alias dsa='docker stop $(docker ps --all --quiet)'

# ======================================
# Docker compose
# ======================================

_complete_services() {
    local MODE="$1"
    if [[ ${MODE} == "single" ]]; then
        shift
    fi
    if [[ ${MODE} == "single" && ${COMP_CWORD} -ge 2 ]]; then
        COMPREPLY=()
        return 0
    fi
    local SERVICES=$(docker compose ps --services 2>/dev/null)
    COMPREPLY=($(compgen -W "${SERVICES}" -- "$2"))
}

_complete_service() {
    _complete_services "single" "$@"
}

# @info Define and run multi-container applications with Docker
# @group docker_compose
alias dc="docker compose"

# @info Build or rebuild services
# @group docker_compose
# @param <SERVICE...>
function dcb() {
    docker compose build "$@"
}
complete -F _complete_services dcb

# @info Stop and remove containers, networks
# @group docker_compose
# @param <SERVICE...>
function dcd() {
    docker compose down --remove-orphans "$@"
}
complete -F _complete_services dcd

# @info Stop and remove containers, networks including volumes
# @group docker_compose
# @param <SERVICE...>
function dcdv() {
    docker compose down --remove-orphans --volumes "$@"
}
complete -F _complete_services dcdv

# @info Execute a command in a running container
# @group docker_compose
# @param <SERVICE>
# @param [COMMAND] {sh}
function dcex() {
    docker compose exec "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_service dce

# @info Execute printenv in a running container
# @group docker_compose
# @param <SERVICE>
# @param [COMMAND] {sh}
function dcexenv() {
    docker compose exec "$1" printenv
}
complete -o nospace -F _complete_service dcenv

# @info Execute a command in a running container, as root
# @group docker_compose
# @param <SERVICE>
# @param [COMMAND] {sh}
function dcexr() {
    docker compose exec --user root "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_service dcer

# @info Return low-level information on Docker objects
# @group docker_compose
# @param <SERVICE>
function dci() {
    docker inspect $(docker compose ps --quiet "$1")
}
complete -o nospace -F _complete_service dci

# @info View output from containers
# @group docker_compose
# @param <SERVICE...>
function dcl() {
    docker compose logs --follow --tail 1000 "$@"
}
complete -F _complete_services dcl

# @info List containers
# @group docker_compose
# @param <SERVICE...>
function dcps() {
    docker compose ps --format "table {{.ID}}\t{{.Name}}\t{{.Service}}\t{{.State}}\t{{.Status}}\t{{.Ports}}" "$@"
}
complete -F _complete_services dcps

# @info Filter running containers list using grep pattern
# @group docker_compose
# @param <SERVICE>
function dcpsf() {
    docker compose ps --format "table {{.ID}}\t{{.Name}}\t{{.Service}}\t{{.State}}\t{{.Status}}\t{{.Ports}}" | grep "$1"
}

# @info Restart service containers
# @group docker_compose
# @param <SERVICE...>
function dcr() {
    docker compose restart "$@"
}
complete -F _complete_services dcr

# @info Restart service containers and view output from containers
# @group docker_compose
# @param <SERVICE...>
function dcrl() {
    docker compose restart "$@" && docker compose logs --follow --tail 1000 "$@"
}
complete -F _complete_services dcrl

# @info Create and start containers
# @group docker_compose
# @param <SERVICE...>
function dcu() {
    docker compose up --detach "$@"
}
complete -F _complete_services dcu

# @info Build, create and start containers
# @group docker_compose
# @param <SERVICE...>
function dcub() {
    docker compose up --detach --build "$@"
}
complete -F _complete_services dcub

# @info Recreate and start containers even if their configuration and image haven't changed
# @group docker_compose
# @param <SERVICE...>
function dcuf() {
    docker compose up --detach --force-recreate "$@"
}
complete -F _complete_services dcuf

# @info Create, start and view output from containers
# @group docker_compose
# @param <SERVICE...>
function dcul() {
    docker compose up --detach "$@" && docker compose logs --follow --tail 1000 "$@"
}
complete -F _complete_services dcul

# ======================================
# git
# ======================================

_complete_branches() {
    if [[ ${COMP_CWORD} -ge 2 ]]; then
        COMPREPLY=()
        return 0
    fi
    local BRANCHES=$(git branch 2>/dev/null | sed 's/^[* ]*//')
    COMPREPLY=($(compgen -W "${BRANCHES}" -- "$2"))
}

# @info List branches
# @group git
alias gib="git branch"

# @info Create branch
# @group git
# @param <NAME>
function gibc() {
    git branch "$1"
}

# @info Create and checkout branch
# @group git
# @param <NAME>
function gibco() {
    git checkout -b "$1"
}

# @info Delete merged branch
# @group git
# @param <BRANCH>
function gibd() {
    git branch -d "$1"
}
complete -o nospace -F _complete_branches gibd

# @info Delete non-merged branch
# @group git
# @param <BRANCH>
function gibdf() {
    git branch -D "$1"
}
complete -o nospace -F _complete_branches gibdf

# @info Rename branch
# @group git
# @param <OLD BRANCH>
# @param <NEW BRANCH>
function gibr() {
    git branch -m "$1" "$2"
}
complete -o nospace -F _complete_branches gibr

# @info Stage and commit all files from current directory
# @group git
# @param [MESSAGE] {WIP}
function gic() {
    git add . && git commit -m "${1:-WIP}"
}

# @info Amend commit
# @group git
# @param [MESSAGE] {WIP}
function gica() {
    git commit --amend -m "${1:-WIP}"
}

# @info Stage, commit and push all files from current directory
# @group git
# @param [MESSAGE] {WIP}
function gicpu() {
    git add . && git commit -m "${1:-WIP}" && git push
}

# @info Stage, commit and force push with lease all files from current directory
# @group git
# @param [MESSAGE] {WIP}
function gicpuf() {
    git add . && git commit -m "${1:-WIP}" && git push --force-with-lease
}

# @info Checkout branch
# @group git
# @param <BRANCH>
function gico() {
    git checkout "$1"
}
complete -o nospace -F _complete_branches gico

# @info Download objects and refs from another repository
# @group git
alias gif="git fetch"

# @info Show commit logs
# @group git
alias gil='git log --graph --pretty=format:"%C(cyan)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(magenta)<%an>%Creset" --abbrev-commit --date=relative'

# @info Join two or more development histories together
# @group git
# @param <BRANCH...>
function gim() {
    git merge "$@"
}
complete -F _complete_branches gim

# @info Fetch from and integrate with another repository or a local branch
# @group git
alias gip="git pull"

# @info Fetch from and integrate with another repository or a local branch using rebase
# @group git
alias gipr="git pull --rebase"

# @info Update remote refs along with associated objects
# @group git
alias gipu="git push"

# @info Force update with lease remote refs along with associated objects
# @group git
alias gipuf="git push --force-with-lease"

# @info Hard reset current HEAD to the specified state
# @group git
# @param <SHA1>
function girh() {
    if [ -z "$1" ]; then
        git reset --hard
    else
        git reset --hard "$1"
    fi
}

# @info Squash commits
# @group git
# @param <SHA1>
# @param <MESSAGE>
function gisq() {
    git reset --soft "$1"
    git commit -m "$2"
}

# @info Squashes ALL commits of the current branch
# @group git
# @param <MESSAGE>
function gisqa() {
    git reset --soft $(git rev-list --max-parents=0 HEAD) && git commit --amend -m "${1:-First commit}"
}

# @info Stash the changes in a dirty working directory away
# @group git
alias gis="git stash"

# @info Remove a single stashed state from the stash list and apply it on top of the current working tree state
# @group git
alias gisp="git stash pop"

# ======================================
# poetry
# ======================================

# @info Install project dependencies
# @group poetry
alias poi="poetry install"

# @info Spawn a shell within the virtual environment
# @group poetry
alias pos="poetry shell"

# ======================================
# Projects
# ======================================

_complete_projects() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=()
    pushd "${HOME}/Projects" >/dev/null
    _filedir -d
    popd >/dev/null
}

# @info Set the current working directory to \`~/Projects\`
# @group projects
alias proj="cd ${HOME}/Projects"

# @info Create a new project in \`~/Projects\`
# @group projects
# @param <NAME>
function projc() {
    mkdir -p "${HOME}/Projects/$1"
    cd "${HOME}/Projects/$1"
    git init
}

# @info Open a project found in \`~/Projects\` with code editor
# @group projects
# @param <NAME>
function projo() {
    code "${HOME}/Projects/$1/"
}
complete -o nospace -F _complete_projects projo

# ======================================
# Misc
# ======================================

# @info Backup files from current directory to \`~/Backups\`
# @group misc
alias backup='zip "$HOME/Backups/$(basename "$PWD" | tr "[:upper:]" "[:lower:]" | tr " " "-")-$(date +%Y%m%d%H%M%S).zip" -r .'

# @info Tail all journal entries
# @group misc
alias logs="sudo journalctl --all --follow"

# @info View all journal entries since last boot
# @group misc
alias logsb="sudo journalctl --boot=-1 --all"

# @info Lists listening TCP/UDP sockets
# @group misc
alias ports="netstat --tcp --udp --listening --programs"

# @info Filter listening TCP/UDP sockets
# @group misc
# @param <PORT>
function portsf() {
    netstat --tcp --udp --listening --programs | grep ":${1}"
}

# @info Pretty prints a json file
# @group misc
# @param <FILE>
function ppjson() {
    jq . ${1} | bat -l json
}

# @info Source \`~/.bashrc\`
# @group misc
alias src="source ${HOME}/.bashrc"

if [ -f ~/.bash_aliases_help ]; then
    . ~/.bash_aliases_help
fi

if [ -f ~/.bash_aliases_private ]; then
    . ~/.bash_aliases_private
fi

ALIASES_DIR="${HOME}/.bash_aliases.d"

if [[ -d "${ALIASES_DIR}" ]]; then
    for ALIASES_FILE in "${ALIASES_DIR}"/{,.}*.sh; do
        if [[ -f "${ALIASES_FILE}" && -r "${ALIASES_FILE}" ]]; then
            source "${ALIASES_FILE}"
        fi
    done
fi
