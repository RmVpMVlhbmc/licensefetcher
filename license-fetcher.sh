#!/usr/bin/env bash

function license-get() { (
  set -e

  while getopts "l:o:s:h" OPT; do
    case "$OPT" in
    l) LICENSE="$OPTARG" ;;
    o) OUTPUT="$OPTARG" ;;
    s) SOURCE="$OPTARG" ;;
    *) echo -e "Usage: ${FUNCNAME[0]} [OPTIONS]\nRetrieve software license for projects\nExample: ${FUNCNAME[0]} -l GPL-3.0-only -o \$PWD\n\nOptions:\n  -l set spdx license identifier\n  -o change output directory\n  -s select alternate license source (fastgit, jsdelivr)" && exit 1 ;;
    esac
  done

  if [ -z "$LICENSE" ]; then
    echo "$0: missing license identifier." && exit 1
  fi

  if [ -z "$OUTPUT"]; then
    OUTPUT='.'
  fi
  SOURCE_BRANCH="$(curl -sS https://api.github.com/repos/spdx/license-list-data | grep -oP '(?<="default_branch": ")\w+(?=")')"
  if [ "$SOURCE" == 'fastgit' ]; then
    SOURCE_URL="https://raw.fastgit.org/spdx/license-list-data/$SOURCE_BRANCH/text/$LICENSE.txt"
  elif [ "$SOURCE" == 'jsdelivr' ]; then
    SOURCE_URL="https://cdn.jsdelivr.net/gh/spdx/license-list-data@$SOURCE_BRANCH/text/$LICENSE.txt"
  else
    SOURCE_URL="https://raw.githubusercontent.com/spdx/license-list-data/$SOURCE_BRANCH/text/$LICENSE.txt"
  fi

  if command -v curl &>/dev/null; then
    curl -sSo "$OUTPUT/LICENSE" "$SOURCE_URL"
  elif command -v wget &>/dev/null; then
    wget -qO "$OUTPUT/LICENSE" "$SOURCE_URL"
  else
    echo "$0: missing program to retrieves license, please install curl or wget."
  fi
)}

function license-list() {
  curl -sS https://api.github.com/repos/spdx/license-list-data/contents/text | grep -oP '(?<="name": ")[a-zA-Z0-9\-\.]+(?=.txt")'
}
