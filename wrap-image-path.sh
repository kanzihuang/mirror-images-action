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
  echo $path_wrapped
done
