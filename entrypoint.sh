#!/bin/bash

set -euo pipefail

if [[ $# != 2 ]]; then
  echo "Usage: $(basename $0) <username> <password>"
  exit 1
fi

username=$1
password=$2

skopeo login --username $username --password $password docker.io
find mirror.d/ -type f -exec xargs -a {} ./copy-image.sh $username \;
