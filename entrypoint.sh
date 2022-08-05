#!/bin/bash

set -euo pipefail

if [[ $# != 4 ]]; then
  echo "Usage: $(basename $0) <registry> <group> <username> <password>"
  exit 1
fi

registry=$1
group=$2
username=$3
password=$4

skopeo login --username $username --password $password $registry

# mirror the below images
# xargs -a ./mirror.d/csi/rook/csi-rook-v17 ./copy-image.sh $registry $group

# mirror all images
# find ./mirror.d/ -type f -exec xargs -a {} ./copy-image.sh $registry $group \;

skopeo logout $registry
