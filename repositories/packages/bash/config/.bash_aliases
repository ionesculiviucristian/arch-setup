# shellcheck shell=bash
# ======================================
# @section File system
# ======================================

# @description Go up a directory level
alias ..="cd ../"

# @description Go up two directory levels
alias ...="cd ../../"

# @description Go up three directory levels
alias ....="cd ../../../"

# @description Go up four directory levels
alias .....="cd ../../../../"

# @description Go up a directory level
alias .1="cd ../"

# @description Go up two directory levels
alias .2="cd ../../"

# @description Go up three directory levels
alias .3="cd ../../../"

# @description Go up four directory levels
alias .4="cd ../../../../"

# @description Show a sorted list of file and directory sizes
function files() {
  du --all --total --human-readable "$@" | sort --human-numeric-sort
}

# @description Show a detailed list of all files and directories
alias ll="eza --long --all --group --group-directories-first --git"

# @description Show disk space for all filesystems
alias space="df --print-type --human-readable --all --total"

# @description Print out a directory structure in a tree-like
alias tree="eza --tree"

# ======================================
# @section Package manager
# ======================================

# @description Install packages
# @arg $@ string PACKAGE
function pkgi() {
  yay --sync --refresh "$@"
}

# @description Remove packages
# @arg $@ string PACKAGE
function pkgr() {
  yay --remove --nosave --recursive "$@"
}

# @description Update packages
alias pkgu="yay --sync --refresh --sysupgrade --devel"

# @description List package sizes with their dependencies
function pkgl() {
  expac --humansize M '%m\t%n' | sort --human-numeric-sort
}

# ======================================
# Completion
# ======================================

function _complete_words() {
  local mode="$1"
  local current="$2"
  shift 2
  if [[ ${mode} == "single" && ${COMP_CWORD} -ge 2 ]]; then
    COMPREPLY=()
    return 0
  fi
  local words
  mapfile -t words < <("$@" 2>/dev/null)
  mapfile -t COMPREPLY < <(compgen -W "${words[*]}" -- "${current}")
}

# ======================================
# @section Docker
# ======================================

function _complete_containers() {
  _complete_words "multiple" "$2" docker ps --format "{{.Names}}"
}

function _complete_container() {
  _complete_words "single" "$2" docker ps --format "{{.Names}}"
}

# @description Execute a command in a running container
# @arg $1 string CONTAINER
# @arg $2 string COMMAND (optional, default: sh)
function dex() {
  docker exec --interactive --tty "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_container dex

# @description Execute printenv in a running container
# @arg $1 string CONTAINER
function dexenv() {
  docker exec "$1" printenv
}
complete -o nospace -F _complete_container dexenv

# @description Execute a command in a running container, as root
# @arg $1 string CONTAINER
# @arg $2 string COMMAND (optional, default: sh)
function dexr() {
  docker exec --interactive --tty --user root "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_container dexr

# @description Return low-level information on Docker objects
# @arg $1 string NAME|ID
function di() {
  docker inspect "$1"
}
complete -o nospace -F _complete_container di

# @description List images
alias dimls="docker image ls"

# @description List all docker images
alias dimlsa="docker image ls --all"

# @description Filter docker images
# @arg $1 string PATTERN
function dimlsf() {
  docker image ls | grep "$1"
}

# @description Fetch the logs of a container
# @arg $1 string CONTAINER
function dl() {
  docker logs --follow --tail 1000 "$1"
}
complete -o nospace -F _complete_container dl

# @description Empty the log files from all containers
function dlclr() {
  docker ps --all --quiet |
    xargs --no-run-if-empty docker inspect --format="{{.LogPath}}" |
    xargs --no-run-if-empty sudo truncate --size=0
}

# @description List all container log files ordered by their size
function dlsz() {
  docker ps --all --quiet |
    xargs --no-run-if-empty docker inspect --format="{{.LogPath}}" |
    xargs --no-run-if-empty sudo du --total --human-readable |
    sort --human-numeric-sort
}

# @description Restart one or more containers
# @arg $@ string CONTAINER
function dr() {
  docker restart "$@"
}
complete -F _complete_containers dr

# @description Restart and fetch the logs of a container
# @arg $1 string CONTAINER
function drl() {
  docker restart "$1" && docker logs --follow --tail 1000 "$1"
}
complete -o nospace -F _complete_container drl

# @description List networks
alias dnls="docker network ls"

# @description Filter docker networks
# @arg $1 string PATTERN
function dnlsf() {
  docker network ls | grep "$1"
}

# @description Remove one or more networks
# @arg $@ string NETWORK
function dnrm() {
  docker network rm "$@"
}

# @description Remove all networks
function dnrma() {
  docker network ls --quiet --filter type=custom | xargs --no-run-if-empty docker network rm
}

# @description List running containers
alias dps="docker ps"

# @description List all containers
alias dpsa="docker ps --all"

# @description Filter all containers list using grep pattern
# @arg $1 string PATTERN
function dpsaf() {
  docker ps --all | grep "$1"
}

# @description Filter running containers list using grep pattern
# @arg $1 string PATTERN
function dpsf() {
  docker ps | grep "$1"
}

# @description Stop one or more running containers
# @arg $@ string CONTAINER
function ds() {
  docker stop "$@"
}
complete -F _complete_containers ds

# @description Stop all running containers
function dsa() {
  docker ps --quiet | xargs --no-run-if-empty docker stop
}

# @description Display container resource usage sorted by highest CPU usage
function dtopc() {
  docker stats --no-stream | (read -r header && echo "${header}" && sort --key=3 --human-numeric-sort --reverse)
}

# @description Display container resource usage sorted by highest memory usage
function dtopm() {
  docker stats --no-stream | (read -r header && echo "${header}" && sort --key=4 --human-numeric-sort --reverse)
}

# @description List volumes
alias dvls="docker volume ls"

# @description Filter docker volumes
# @arg $1 string PATTERN
function dvlsf() {
  docker volume ls | grep "$1"
}

# @description Remove one or more volumes
# @arg $@ string VOLUME
function dvrm() {
  docker volume rm "$@"
}

# @description Remove all volumes
function dvrma() {
  docker volume ls --quiet | xargs --no-run-if-empty docker volume rm
}

# ======================================
# @section Docker compose
# ======================================

function _complete_services() {
  _complete_words "multiple" "$2" docker compose ps --services
}

function _complete_service() {
  _complete_words "single" "$2" docker compose ps --services
}
# @description Define and run multi-container applications with Docker
alias dc="docker compose"

# @description Build or rebuild services
# @arg $@ string SERVICE
function dcb() {
  docker compose build "$@"
}
complete -F _complete_services dcb

# @description Stop and remove containers
# @arg $@ string SERVICE
function dcd() {
  docker compose stop "$@" && docker compose rm --force "$@"
}
complete -F _complete_services dcd

# @description Stop and remove containers, including volumes
# @arg $@ string SERVICE
function dcdv() {
  local services=("$@")
  local volumes=()

  for service in "${services[@]}"; do
    local container_id
    container_id=$(docker compose ps --quiet "${service}")

    local container_volumes
    container_volumes=$(docker inspect "${container_id}" --format '{{ range .Mounts }}{{ if eq .Type "volume" }}{{ .Name }} {{ end }}{{ end }}')

    for container_volume in ${container_volumes}; do
      volumes+=("${container_volume}")
    done
  done

  docker compose stop "${services[@]}"
  docker compose rm --force --volumes "${services[@]}"

  for volume in "${volumes[@]}"; do
    docker volume rm "${volume}"
  done
}
complete -F _complete_services dcdv

# @description Execute a command in a running container
# @arg $1 string SERVICE
# @arg $2 string COMMAND (optional, default: sh)
function dcex() {
  docker compose exec "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_service dcex

# @description Execute printenv in a running container
# @arg $1 string SERVICE
function dcexenv() {
  docker compose exec "$1" printenv
}
complete -o nospace -F _complete_service dcexenv

# @description Execute a command in a running container, as root
# @arg $1 string SERVICE
# @arg $2 string COMMAND (optional, default: sh)
function dcexr() {
  docker compose exec --user root "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_service dcexr

# @description Return low-level information on Docker objects
# @arg $1 string SERVICE
function dci() {
  docker inspect "$(docker compose ps --quiet "$1")"
}
complete -o nospace -F _complete_service dci

# @description View output from containers
# @arg $@ string SERVICE
function dcl() {
  docker compose logs --follow --tail 1000 "$@"
}
complete -F _complete_services dcl

# @description List containers
# @arg $@ string SERVICE
function dcps() {
  docker compose ps --format "table {{.ID}}\t{{.Name}}\t{{.Service}}\t{{.State}}\t{{.Status}}\t{{.Ports}}" "$@"
}
complete -F _complete_services dcps

# @description Filter running containers list using grep pattern
# @arg $1 string PATTERN
function dcpsf() {
  docker compose ps --format "table {{.ID}}\t{{.Name}}\t{{.Service}}\t{{.State}}\t{{.Status}}\t{{.Ports}}" | grep "$1"
}

# @description Restart service containers
# @arg $@ string SERVICE
function dcr() {
  docker compose restart "$@"
}
complete -F _complete_services dcr

# @description Restart service containers and view their output
# @arg $@ string SERVICE
function dcrl() {
  docker compose restart "$@" && docker compose logs --follow --tail 1000 "$@"
}
complete -F _complete_services dcrl

# @description Create and start containers
# @arg $@ string SERVICE
function dcu() {
  docker compose up --remove-orphans --detach "$@"
}
complete -F _complete_services dcu

# @description Build, create and start containers
# @arg $@ string SERVICE
function dcub() {
  docker compose up --remove-orphans --detach --build "$@"
}
complete -F _complete_services dcub

# @description Recreate and start containers even if their configuration and image haven't changed
# @arg $@ string SERVICE
function dcuf() {
  docker compose up --remove-orphans --detach --force-recreate "$@"
}
complete -F _complete_services dcuf

# @description Create, start and view output from containers
# @arg $@ string SERVICE
function dcul() {
  docker compose up --remove-orphans --detach "$@" && docker compose logs --follow --tail 1000 "$@"
}
complete -F _complete_services dcul

# ======================================
# @section git
# ======================================

function _complete_branches() {
  _complete_words "single" "$2" git branch --format="%(refname:short)"
}

# @description Stage and commit all files from current directory
# @arg $1 string MESSAGE (optional, default: WIP)
function gic() {
  git add --all && git commit --message="${1:-WIP}"
}

# @description Amend commit
alias gica="git add --all && git commit --amend --no-edit"

# @description Create and switch to branch
# @arg $1 string BRANCH
function gicb() {
  git switch --create "$1"
}

# @description Switch to branch
# @arg $1 string BRANCH
function gicob() {
  git switch "$1"
}
complete -o nospace -F _complete_branches gicob

# @description Stage, commit and push all files from current directory
# @arg $1 string MESSAGE (optional, default: WIP)
function gicpu() {
  git add --all && git commit --message="${1:-WIP}" && git push
}

# @description Stage, commit and force push with lease all files from current directory
# @arg $1 string MESSAGE (optional, default: WIP)
function gicpuf() {
  git add --all && git commit --message="${1:-WIP}" && git push --force-with-lease
}

# @description Download objects and refs from another repository
alias gif="git fetch"

# @description Show commit logs
alias gil='git log --graph --pretty=format:"%C(cyan)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(magenta)<%an>%Creset" --abbrev-commit --date=relative'

# @description List branches
alias gilsb="git branch"

# @description Join two or more development histories together
# @arg $@ string BRANCH
function gim() {
  git merge "$@"
}
complete -F _complete_branches gim

# @description Fetch from and integrate with another repository or a local branch
alias gip="git pull"

# @description Fetch from and integrate with another repository or a local branch using rebase
alias gipr="git pull --rebase"

# @description Update remote refs along with associated objects
alias gipu="git push"

# @description Force update with lease remote refs along with associated objects
alias gipuf="git push --force-with-lease"

# @description Rename branch
# @arg $1 string OLD_BRANCH
# @arg $2 string NEW_BRANCH
function girb() {
  git branch --move "$1" "$2"
}
complete -o nospace -F _complete_branches girb

# @description Hard reset current HEAD to the specified state
# @arg $1 string SHA1 (optional, default: HEAD)
function girh() {
  git reset --hard "${1:-HEAD}"
}

# @description Stash the changes in a dirty working directory away
alias gis="git stash push"

# @description Remove a single stashed state from the stash list and apply it on top of the current working tree state
alias gisp="git stash pop"

# @description Squash commits
# @arg $1 string SHA1
# @arg $2 string MESSAGE
function gisq() {
  git reset --soft "$1" && git commit --message="$2"
}

# @description Squashes ALL commits of the current branch
# @arg $1 string MESSAGE (optional, default: First commit)
function gisqa() {
  git reset --soft "$(git rev-list --max-parents=0 HEAD)" && git commit --amend --message="${1:-First commit}"
}

# ======================================
# @section tmux
# ======================================

function _complete_sessions() {
  _complete_words "single" "$2" tmux list-sessions -F "#{session_name}"
}

# @description Attach to a session
# @arg $1 string SESSION (optional)
function tas() {
  if [[ -z ${1:-} ]]; then
    tmux attach-session
  else
    tmux attach-session -t "$1"
  fi
}
complete -o nospace -F _complete_sessions tas

# @description Kill/delete a session
# @arg $1 string SESSION
function tks() {
  tmux kill-session -t "$1"
}
complete -o nospace -F _complete_sessions tks

# @description Kill/delete all sessions
alias tksrv="tmux kill-server"

# @description Show all sessions
alias tls="tmux list-sessions"

# @description Start a new session
# @arg $1 string SESSION (optional)
function tns() {
  if [[ -z ${1:-} ]]; then
    tmux new-session
  else
    tmux new-session -s "$1"
  fi
}
complete -o nospace -F _complete_sessions tns

# ======================================
# @section Projects
# ======================================

# @description Set the current working directory to \`~/Projects\`
alias proj='cd "${HOME}/Projects"'

# ======================================
# @section Misc
# ======================================

# @description Backup files from current directory to \`~/Backups\`
function backup() {
  local name
  name=$(basename "${PWD}" | tr "[:upper:]" "[:lower:]" | tr " " "-")
  bsdtar --auto-compress --create --file "${HOME}/Backups/${name}-$(date +%Y%m%d%H%M%S).zip" .
}

# @description Tail all journal entries
alias logs="sudo journalctl --all --follow"

# @description View all journal entries of a boot, relative to the current one
# @arg $1 string BOOT (optional, default: -1)
function logsb() {
  sudo journalctl --boot="${1:--1}" --all
}

# @description Lists listening TCP/UDP sockets
alias ports="ss --tcp --udp --listening --numeric --processes"

# @description Filter listening TCP/UDP sockets
# @arg $1 string PORT
function portsf() {
  ss --tcp --udp --listening --numeric --processes "( sport = :$1 )"
}

# @description Pretty prints a json file
# @arg $1 string FILE
function ppjson() {
  yq -o=json . "$1" | bat --language=json
}

# @description Source \`~/.bashrc\`
alias src='source "${HOME}/.bashrc"'

if [[ -f "${HOME}/.bash_aliases_help" ]]; then
  # shellcheck disable=SC1091
  . "${HOME}/.bash_aliases_help"
fi

if [[ -f "${HOME}/.bash_private_aliases" ]]; then
  # shellcheck disable=SC1091
  . "${HOME}/.bash_private_aliases"
fi

if [[ -d "${HOME}/.bash_aliases.d" ]]; then
  for aliases_file in "${HOME}/.bash_aliases.d"/{,.}*.sh; do
    if [[ -f "${aliases_file}" && -r "${aliases_file}" ]]; then
      # shellcheck disable=SC1090
      source "${aliases_file}"
    fi
  done
  unset aliases_file
fi
