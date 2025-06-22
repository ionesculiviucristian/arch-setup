#!/bin/bash

PACKAGES_FILE="./data/packages.json"

if [ ! -f "$PACKAGES_FILE" ]; then
  echo "Error: $PACKAGES_FILE not found."
  exit 1
fi

jq -r 'keys_unsorted[] | select(. != "external")' "$PACKAGES_FILE" | while read -r section; do
  OUTPUT_FILE="./data/lists/${section}.txt"

  jq --arg section_name "$section" -r '.[$section_name][] | .name' "$PACKAGES_FILE" > "$OUTPUT_FILE"
done
