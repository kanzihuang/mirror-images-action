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
  [[ "$path_wraped" != "$path_original" ]] && skopeo copy --all docker://$path_original docker://$path_wraped
done
