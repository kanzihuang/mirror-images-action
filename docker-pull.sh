#!/bin/bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $(basename $0) <account> <image-path>..."
  exit 1
fi

account="$1" && shift
source $(dirname $0)/utils.sh

for path_original in $@; do
  path_wraped=$(wrap_image_path $path_original)
  sudo docker pull $path_wraped
  if [[ "$path_wraped" != "$path_original" ]]; then
    sudo docker tag "$path_wraped" "$path_original"
    sudo docker rmi "$path_wraped"
  fi

done
