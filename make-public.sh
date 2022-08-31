#!/bin/bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename $0) <image-path>..."
  exit 1
fi

generate_image_path="$(dirname $0)/generate-image-path.sh"
function generate-image-name() {
  image_source=$1
  name=$($generate_image_path docker.io/kanzihuang $image_source)
  name=${name##*/}
  name=${name%:*}
  echo $name
}

for image_source in "$@"; do
  image_name=$(generate-image-name $image_source)
  cat make-public.curl | \
    sed 's/\\$//' | \
    sed "/^curl/{s/^curl//; s/[^/]*\('\s*\)$/${image_name}\1/}" | \
    xargs curl
  sleep 1
done
