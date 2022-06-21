#!/bin/bash

function wrap_image_path() {
  path_original=$1
  case $path_original in
    registry\.k8s\.io/* | \
    k8s\.gcr\.io/* )
      echo "docker.io/$account/${path_original//\//_slash_}"
      ;;
    *)
      echo "$path_original"
      ;;
  esac
}
