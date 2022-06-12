#!/bin/bash

set -euo pipefail

if [[ $# < 2 ]]; then
	echo "Usage: $(basename $0) <account> <image-path>..."
	exit 1
fi

account="$1"
shift

for path_original in $@; do
	if [[ "$path_original" =~ (sudo nerdctl -n k8s.io.io/)?"$account"/* ]]; then
		path_wraped="$path_original"
	else
		path_wraped="docker.io/$account/${path_original//\//_slash_}"
	fi

	sudo nerdctl -n k8s.io pull $path_wraped
	if [[ "$path_wraped" != "$path_original" ]]; then
		sudo nerdctl -n k8s.io tag "$path_wraped" "$path_original"
		sudo nerdctl -n k8s.io rmi "$path_wraped"
  fi

done
