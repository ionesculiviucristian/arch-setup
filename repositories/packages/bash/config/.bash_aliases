# shellcheck disable=SC2148
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

# @info Show a sorted list of file and directory sizes
# @group files
function files() {
  du --all --total --human-readable "$@" | sort --human-numeric-sort
}

# @info Show a detailed list of all files and directories
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

# @info Install packages
# @group pkgmgr
# @param <PACKAGE...>
function pkgi() {
  yay --sync --refresh "$@"
}

# @info Remove packages
# @group pkgmgr
# @param <PACKAGE...>
function pkgr() {
  yay --remove --nosave --recursive "$@"
}

# @info Update packages
# @group pkgmgr
alias pkgu="yay --sync --refresh --sysupgrade --devel"

# @info List package sizes with their dependencies
# @group pkgmgr
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
# Docker
# ======================================

function _complete_containers() {
  _complete_words "multiple" "$2" docker ps --format "{{.Names}}"
}

function _complete_container() {
  _complete_words "single" "$2" docker ps --format "{{.Names}}"
}

# @info Execute a command in a running container
# @group docker
# @param <CONTAINER>
# @param [COMMAND] {sh}
function dex() {
  docker exec --interactive --tty "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_container dex

# @info Execute printenv in a running container
# @group docker
# @param <CONTAINER>
function dexenv() {
  docker exec "$1" printenv
}
complete -o nospace -F _complete_container dexenv

# @info Execute a command in a running container, as root
# @group docker
# @param <CONTAINER>
# @param [COMMAND] {sh}
function dexr() {
  docker exec --interactive --tty --user root "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_container dexr

# @info Return low-level information on Docker objects
# @group docker
# @param <NAME|ID>
function di() {
  docker inspect "$1"
}
complete -o nospace -F _complete_container di

# @info List images
# @group docker
alias dimls="docker image ls"

# @info List all docker images
# @group docker
alias dimlsa="docker image ls --all"

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
  docker logs --follow --tail 1000 "$1"
}
complete -o nospace -F _complete_container dl

# @info Empty the log files from all containers
# @group docker
function dlclr() {
  docker ps --all --quiet |
    xargs --no-run-if-empty docker inspect --format="{{.LogPath}}" |
    xargs --no-run-if-empty sudo truncate --size=0
}

# @info List all container log files ordered by their size
# @group docker
function dlsz() {
  docker ps --all --quiet |
    xargs --no-run-if-empty docker inspect --format="{{.LogPath}}" |
    xargs --no-run-if-empty sudo du --total --human-readable |
    sort --human-numeric-sort
}

# @info Restart one or more containers
# @group docker
# @param <CONTAINER...>
function dr() {
  docker restart "$@"
}
complete -F _complete_containers dr

# @info Restart and fetch the logs of a container
# @group docker
# @param <CONTAINER>
function drl() {
  docker restart "$1" && docker logs --follow --tail 1000 "$1"
}
complete -o nospace -F _complete_container drl

# @info List networks
# @group docker
alias dnls="docker network ls"

# @info Filter docker networks
# @group docker
# @param <PATTERN>
function dnlsf() {
  docker network ls | grep "$1"
}

# @info Remove one or more networks
# @group docker
# @param <NETWORK...>
function dnrm() {
  docker network rm "$@"
}

# @info Remove all networks
# @group docker
function dnrma() {
  docker network ls --quiet --filter type=custom | xargs --no-run-if-empty docker network rm
}

# @info List running containers
# @group docker
alias dps="docker ps"

# @info List all containers
# @group docker
alias dpsa="docker ps --all"

# @info Filter all containers list using grep pattern
# @group docker
# @param <PATTERN>
function dpsaf() {
  docker ps --all | grep "$1"
}

# @info Filter running containers list using grep pattern
# @group docker
# @param <PATTERN>
function dpsf() {
  docker ps | grep "$1"
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
function dsa() {
  docker ps --quiet | xargs --no-run-if-empty docker stop
}

# @info Display container resource usage sorted by highest CPU usage
# @group docker
function dtopc() {
  docker stats --no-stream | (read -r header && echo "${header}" && sort --key=3 --human-numeric-sort --reverse)
}

# @info Display container resource usage sorted by highest memory usage
# @group docker
function dtopm() {
  docker stats --no-stream | (read -r header && echo "${header}" && sort --key=4 --human-numeric-sort --reverse)
}

# @info List volumes
# @group docker
alias dvls="docker volume ls"

# @info Filter docker volumes
# @group docker
# @param <PATTERN>
function dvlsf() {
  docker volume ls | grep "$1"
}

# @info Remove one or more volumes
# @group docker
# @param <VOLUME...>
function dvrm() {
  docker volume rm "$@"
}

# @info Remove all volumes
# @group docker
function dvrma() {
  docker volume ls --quiet | xargs --no-run-if-empty docker volume rm
}

# ======================================
# Docker compose
# ======================================

function _complete_services() {
  _complete_words "multiple" "$2" docker compose ps --services
}

function _complete_service() {
  _complete_words "single" "$2" docker compose ps --services
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

# @info Stop and remove containers
# @group docker_compose
# @param <SERVICE...>
function dcd() {
  docker compose stop "$@" && docker compose rm --force "$@"
}
complete -F _complete_services dcd

# @info Stop and remove containers, including volumes
# @group docker_compose
# @param <SERVICE...>
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

# @info Execute a command in a running container
# @group docker_compose
# @param <SERVICE>
# @param [COMMAND] {sh}
function dcex() {
  docker compose exec "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_service dcex

# @info Execute printenv in a running container
# @group docker_compose
# @param <SERVICE>
function dcexenv() {
  docker compose exec "$1" printenv
}
complete -o nospace -F _complete_service dcexenv

# @info Execute a command in a running container, as root
# @group docker_compose
# @param <SERVICE>
# @param [COMMAND] {sh}
function dcexr() {
  docker compose exec --user root "$1" sh -c "${2:-sh}"
}
complete -o nospace -F _complete_service dcexr

# @info Return low-level information on Docker objects
# @group docker_compose
# @param <SERVICE>
function dci() {
  docker inspect "$(docker compose ps --quiet "$1")"
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
# @param <PATTERN>
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

# @info Restart service containers and view their output
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
  docker compose up --remove-orphans --detach "$@"
}
complete -F _complete_services dcu

# @info Build, create and start containers
# @group docker_compose
# @param <SERVICE...>
function dcub() {
  docker compose up --remove-orphans --detach --build "$@"
}
complete -F _complete_services dcub

# @info Recreate and start containers even if their configuration and image haven't changed
# @group docker_compose
# @param <SERVICE...>
function dcuf() {
  docker compose up --remove-orphans --detach --force-recreate "$@"
}
complete -F _complete_services dcuf

# @info Create, start and view output from containers
# @group docker_compose
# @param <SERVICE...>
function dcul() {
  docker compose up --remove-orphans --detach "$@" && docker compose logs --follow --tail 1000 "$@"
}
complete -F _complete_services dcul

# ======================================
# git
# ======================================

function _complete_branches() {
  _complete_words "single" "$2" git branch --format="%(refname:short)"
}

# @info Stage and commit all files from current directory
# @group git
# @param [MESSAGE] {WIP}
function gic() {
  git add --all && git commit --message="${1:-WIP}"
}

# @info Amend commit
# @group git
alias gica="git add --all && git commit --amend --no-edit"

# @info Create and switch to branch
# @group git
# @param <BRANCH>
function gicb() {
  git switch --create "$1"
}

# @info Switch to branch
# @group git
# @param <BRANCH>
function gicob() {
  git switch "$1"
}
complete -o nospace -F _complete_branches gicob

# @info Stage, commit and push all files from current directory
# @group git
# @param [MESSAGE] {WIP}
function gicpu() {
  git add --all && git commit --message="${1:-WIP}" && git push
}

# @info Stage, commit and force push with lease all files from current directory
# @group git
# @param [MESSAGE] {WIP}
function gicpuf() {
  git add --all && git commit --message="${1:-WIP}" && git push --force-with-lease
}

# @info Download objects and refs from another repository
# @group git
alias gif="git fetch"

# @info Show commit logs
# @group git
alias gil='git log --graph --pretty=format:"%C(cyan)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(magenta)<%an>%Creset" --abbrev-commit --date=relative'

# @info List branches
# @group git
alias gilsb="git branch"

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

# @info Rename branch
# @group git
# @param <OLD BRANCH>
# @param <NEW BRANCH>
function girb() {
  git branch --move "$1" "$2"
}
complete -o nospace -F _complete_branches girb

# @info Hard reset current HEAD to the specified state
# @group git
# @param [SHA1] {HEAD}
function girh() {
  git reset --hard "${1:-HEAD}"
}

# @info Stash the changes in a dirty working directory away
# @group git
alias gis="git stash push"

# @info Remove a single stashed state from the stash list and apply it on top of the current working tree state
# @group git
alias gisp="git stash pop"

# @info Squash commits
# @group git
# @param <SHA1>
# @param <MESSAGE>
function gisq() {
  git reset --soft "$1" && git commit --message="$2"
}

# @info Squashes ALL commits of the current branch
# @group git
# @param [MESSAGE] {First commit}
function gisqa() {
  git reset --soft "$(git rev-list --max-parents=0 HEAD)" && git commit --amend --message="${1:-First commit}"
}

# ======================================
# poetry
# ======================================

# @info Install project dependencies
# @group poetry
alias poi="poetry install"

# @info Activate the virtual environment in the current shell
# @group poetry
function pos() {
  eval "$(poetry env activate)"
}

# ======================================
# tmux
# ======================================

function _complete_sessions() {
  _complete_words "single" "$2" tmux list-sessions -F "#{session_name}"
}

# @info Attach to a session
# @group tmux
# @param [SESSION]
function tas() {
  if [[ -z ${1:-} ]]; then
    tmux attach-session
  else
    tmux attach-session -t "$1"
  fi
}
complete -o nospace -F _complete_sessions tas

# @info Kill/delete a session
# @group tmux
# @param <SESSION>
function tks() {
  tmux kill-session -t "$1"
}
complete -o nospace -F _complete_sessions tks

# @info Kill/delete all sessions
# @group tmux
alias tksrv="tmux kill-server"

# @info Show all sessions
# @group tmux
alias tls="tmux list-sessions"

# @info Start a new session
# @group tmux
# @param [SESSION]
function tns() {
  if [[ -z ${1:-} ]]; then
    tmux new-session
  else
    tmux new-session -s "$1"
  fi
}
complete -o nospace -F _complete_sessions tns

# ======================================
# Projects
# ======================================

# @info Set the current working directory to \`~/Projects\`
# @group projects
alias proj='cd "${HOME}/Projects"'

# ======================================
# Misc
# ======================================

# @info Backup files from current directory to \`~/Backups\`
# @group misc
function backup() {
  local name
  name=$(basename "${PWD}" | tr "[:upper:]" "[:lower:]" | tr " " "-")
  zip --recurse-paths "${HOME}/Backups/${name}-$(date +%Y%m%d%H%M%S).zip" .
}

# @info Tail all journal entries
# @group misc
alias logs="sudo journalctl --all --follow"

# @info View all journal entries of a boot, relative to the current one
# @group misc
# @param [BOOT] {-1}
function logsb() {
  sudo journalctl --boot="${1:--1}" --all
}

# @info Lists listening TCP/UDP sockets
# @group misc
alias ports="ss --tcp --udp --listening --numeric --processes"

# @info Filter listening TCP/UDP sockets
# @group misc
# @param <PORT>
function portsf() {
  ss --tcp --udp --listening --numeric --processes "( sport = :$1 )"
}

# @info Pretty prints a json file
# @group misc
# @param <FILE>
function ppjson() {
  jq . "$1" | bat --language=json
}

# @info Source \`~/.bashrc\`
# @group misc
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
