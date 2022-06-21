#!/bin/bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $(dirname $0) <account> <image-path>..."
  exit 1
fi

account=$1 && shift
source "$(dirname $0)/utils.sh"

for path_original in "$@"; do
  path_wraped=$(wrap_image_path $path_original)
  [[ "$path_wraped" == "$path_original" ]] && continue

  if ! layers_original="$(skopeo inspect -f {{.Layers}} docker://$path_original 2> /dev/null)"; then
    echo "Failed to inspect source image: $path_original"
    continue
  fi

  if ! layers_wraped="$(skopeo inspect -f {{.Layers}} docker://$path_wraped 2> /dev/null)"; then
    layers_wraped=""
  fi

  if [[ -z "$layers_wraped" || "$layers_wraped" != "$layers_original" ]]; then
    skopeo copy docker://$path_original docker://$path_wraped
    echo "Image '$path_original' was copied to hub.hocker.com/$account"
  else
    echo "Image '$path_original' already exists on hub.hocker.com/$account"
  fi

done
