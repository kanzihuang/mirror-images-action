#!/bin/bash

set -euo pipefail

if [[ $# != 2 ]]; then
	echo "Usage: $(basename $0) <username> <password>"
	exit 1
fi

username=$1
password=$2

skopeo login --username $username --password $password docker.io

for arg_file in mirror.d/* ; do
	xargs -a $arg_file ./copy-image.sh $username
	# for image_path in "$(cat $arg_file)"; do
  #  ./copy-image.sh $username $image_path
  # done
done
