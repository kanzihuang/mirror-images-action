#!/bin/bash

function wrap_image_path() {
  path_original=$1
	if [[ $# == 1 ]]; then
		swr="docker.io"
	else
		swr="swr.cn-north-4.myhuaweicloud.com"
	fi
  case $path_original in
		gcr\.io/* | k8s\.gcr\.io/* | \
		registry\.k8s\.io/* )
      echo "$swr/$account/${path_original//\//_slash_}"
      ;;
    *)
      echo "$path_original"
      ;;
  esac
}
