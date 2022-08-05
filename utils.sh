#!/bin/bash

function wrap_image_path() {
  registry=$1
  group=$2
  path_original=$3
  case $path_original in
    gcr\.io/* | k8s\.gcr\.io/* | \
    registry\.k8s\.io/* )
      echo "$registry/$group/${path_original//\//_slash_}"
      ;;
    *)
      echo "$path_original"
      ;;
  esac
}
