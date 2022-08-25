#!/bin/bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename $0) <image-path>..."
  exit 1
fi

source "$(dirname $0)/utils.sh"
function get-image-name-wrapped() {
  registry=docker.io
  group=kanzihuang
  path_original=$1
  wrapped=$(wrap_image_path docker.io kanzihuang $path_original)
  trimmed=${wrapped##*/}
  trimmed=${trimmed%:*}
  echo $trimmed
}

for path_original in "$@"; do
  name_wrapped=$(get-image-name-wrapped $path_original)
  cat make-public.curl | \
    sed "s/\\\\$//" | \
    sed "/^curl/{s/^curl//; s/[-._[:alnum:]]*\('\s*\)$/${name_wrapped}\1/}" | \
    xargs curl
  sleep 1
done
