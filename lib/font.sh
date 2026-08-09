# shellcheck shell=bash

# @description Install the latest release of the external fonts.
# @noargs
# @exitcode 1 GitHub API unreachable, no matching asset or failed extraction
font::install_external() {
  local yml source_url asset pattern archive_url release tmp_dir

  for yml in "${arch_setup_dir:?}"/repositories/fonts/*.yml; do
    [ "$(package::repository_type "${yml}")" = "external" ] || continue

    source_url=$(yq -r '.source.url' "${yml}")
    source_url=${source_url%/}
    asset=$(yq -r '.source.release_asset // ""' "${yml}")
    pattern=$(yq -r '.source.release_asset_pattern // ""' "${yml}")

    if [ -n "${asset}" ]; then
      archive_url="${source_url}/releases/latest/download/${asset}"
    elif [ -z "${pattern}" ]; then
      log::error "No source.release_asset or source.release_asset_pattern in ${yml}"
      return 1
    else
      local api_url="https://api.github.com/repos/${source_url#https://github.com/}/releases/latest"

      if ! release=$(wget -qO- "${api_url}"); then
        log::error "Could not read ${api_url}"
        return 1
      fi

      archive_url=$(ASSET_REGEX=${pattern} yq -p=json -r '[.assets[] | select(.name | test(env(ASSET_REGEX)))][0].browser_download_url // ""' <<<"${release}")

      if [ -z "${archive_url}" ]; then
        log::error "No asset matching ${pattern} in ${api_url}"
        return 1
      fi
    fi

    tmp_dir=$(mktemp -d)
    request::extract "${archive_url}" "${tmp_dir}"

    find "${tmp_dir}" -type f \( -iname "*.ttf" -o -iname "*.otf" \) \
      -exec install -D -m 644 --target-directory "${HOME}/.local/share/fonts" {} +

    rm -rf "${tmp_dir}"
  done

  fc-cache -f >/dev/null
}
