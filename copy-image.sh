#!/bin/bash

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $(basename $0) <registry-source> <registry-destination> <image-source>..."
  exit 1
fi

registry_source=$1 && shift
registry_destination=$1 && shift
generate_image_path="$(dirname $0)/generate-image-path.sh"

for image_source in "$@"; do
  path_wrapped=$($generate_image_path $registry_destination $image_source)
  [[ $registry_source != "ORIGIN" ]] && image_source=$($generate_image_path $registry_source $image_source)
  echo "skopeo copy docker://$image_source docker://$path_wrapped"
  if [[ "$path_wrapped" != "$image_source" ]]; then
    if ! time skopeo copy --retry-times 3 docker://$image_source docker://$path_wrapped; then
      docker pull $image_source
      docker tag $image_source $path_wrapped
      docker push $path_wrapped
    fi
  fi
done
