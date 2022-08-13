#!/bin/bash

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $(basename $0) <registry> <group> <image-path>..."
  exit 1
fi

registry=$1 && shift
group=$1 && shift
source "$(dirname $0)/utils.sh"

for path_original in "$@"; do
  path_wrapped=$(wrap_image_path $registry $group $path_original)
  echo "skopeo copy --all  docker://$path_original docker://$path_wrapped"
  if [[ "$path_wrapped" != "$path_original" ]]; then
    if ! skopeo copy --all --retry-times 3 docker://$path_original docker://$path_wrapped; then
      docker pull $path_original
      docker tag $path_original $path_wrapped
      docker push $path_wrapped
    fi
  fi
done
