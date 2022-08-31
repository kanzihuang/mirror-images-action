#!/bin/bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $(basename $0) <registry-destination> <image-path>..."
  exit 1
fi

registry_destination="$1" && shift
generate_image_path="$(dirname $0)/generate-image-path.sh"

for image_path in $@; do
  path_wraped=$("$generate_image_path" "$registry_destination" "$image_path")
  sudo nerdctl -n k8s.io pull $path_wraped
  if [[ "$path_wraped" != "$image_path" ]]; then
    sudo nerdctl -n k8s.io tag "$path_wraped" "$image_path"
    sudo nerdctl -n k8s.io rmi "$path_wraped"
  fi

done
