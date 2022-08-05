#!/bin/bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $(basename $0) <account> <image-path>..."
  exit 1
fi

account="$1" && shift
source $(dirname $0)/utils.sh

for path_original in $@; do
  path_wraped=$(wrap_image_path $path_original swr.cn-north-4.myhuaweicloud.com)
  sudo nerdctl -n k8s.io pull $path_wraped
  if [[ "$path_wraped" != "$path_original" ]]; then
    sudo nerdctl -n k8s.io tag "$path_wraped" "$path_original"
    sudo nerdctl -n k8s.io rmi "$path_wraped"
  fi

done
