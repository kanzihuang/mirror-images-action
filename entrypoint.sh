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

sed --version

# mirror the below images
# cat mirror.d/cluster/kubespray/kubespray-v2.20-images.list \
echo gcr.io/istio-testing/build-tools:master-34b06c08ee613a15e08c5888ac269ad22f23d23e \
  | xargs ./copy-image.sh ORIGIN $registry/$group

# mirror all images
# find mirror.d/cluster/kubespray/ -type f -exec cat {} + | xargs ./copy-image.sh $registry $group

skopeo logout $registry
docker logout $registry
