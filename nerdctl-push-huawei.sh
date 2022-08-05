#!/bin/bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $(dirname $0) <account> <image-path>..."
  exit 1
fi

account=$1 && shift
source "$(dirname $0)/utils.sh"

for path_original in "$@"; do
  path_wraped=$(wrap_image_path $path_original swr.cn-north-4.myhuaweicloud.com)
  if [[ "$path_wraped" != "$path_original" ]]; then
		sudo nerdctl -n k8s.io tag $path_original $path_wraped
		sudo nerdctl -n k8s.io push $path_wraped
		sudo nerdctl -n k8s.io rmi $path_wraped
	fi
done
