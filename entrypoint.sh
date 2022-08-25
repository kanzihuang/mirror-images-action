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

docker login --username $username --password $password $registry
skopeo login --username $username --password $password $registry

# mirror the below images
cat ./mirror.d/cluster/kubespray/* | \
  grep "^quay.io/kubespray/kubespray" | \
  xargs ./copy-image.sh $registry $group

# mirror all images
# find mirror.d/cluster/kubespray/ -type f -exec cat {} + | xargs ./copy-image.sh $registry $group

skopeo logout $registry
docker logout $registry
