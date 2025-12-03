#!/bin/bash
set -eu

ID=$1
entry=$'\n'

while IFS= read -r line; do
  entry+="${line}"$'\n'
done

if [ -z "${ID}" ]; then
  echo "Error: ID is required"
  exit 1
fi

entry_start="# >>> ${ID} initialize >>>"
entry_end="# <<< ${ID} initialize <<<"

bashrc_file="${HOME}/.bashrc"

if grep -qF "${entry_start}" "${bashrc_file}"; then
  tmp_file=$(mktemp)
  trap 'rm -f "${tmp_file}"' EXIT

  awk -v start="${entry_start}" -v end="${entry_end}" -v entry="${entry}" '
    $0 ~ start {
      print;
      print entry;
      p=1;
      next;
    }
    $0 ~ end {
      p=0;
      print;
      next;
    }
    p==0 {
      print;
    }
  ' "${bashrc_file}" > "${tmp_file}" && mv "${tmp_file}" "${bashrc_file}"
else
  {
    echo ""
    echo "${entry_start}"
    echo "${entry}"
    echo "${entry_end}"
    echo ""
  } >> "${bashrc_file}"
fi

exit 0
