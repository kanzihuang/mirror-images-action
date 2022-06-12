#!/bin/bash

set -euo pipefail

if [[ $# < 2 ]]; then
	echo "Usage: $(basename $0) <account> <image-path>..."
	exit 1
fi

account="$1"
shift

for path_original in $@; do
	if [[ "$path_original" =~ (docker.io/)?"$account"/* ]]; then
		path_wraped="$path_original"
	else
		path_wraped="docker.io/$account/${path_original//\//_slash_}"
	fi

	docker pull $path_wraped
	if [[ "$path_wraped" != "$path_original" ]]; then
		docker tag "$path_wraped" "$path_original"
		docker rmi "$path_wraped"
  fi

done
