#!/bin/bash

function wrap_image_path() {
  path_original=$1
  case $path_original in
		gcr\.io/* | k8s\.gcr\.io/* | \
		registry\.k8s\.io/* )
      echo "docker.io/$account/${path_original//\//_slash_}"
      ;;
    *)
      echo "$path_original"
      ;;
  esac
}
