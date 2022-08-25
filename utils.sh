#!/bin/bash

function wrap_image_path() {
  registry=$1
  group=$2
  path_original=$3

  pattern='*([-_.:[:alnum:]])'
  declare -A dict
  dict=(
    [docker.io/library/]=""
    [docker.io/kanzihuang/]=""
    [registry.k8s.io/]=""
    [k8s.gcr.io/]=""
    [quay.io/coreos/etcd]="etcd"
    [quay.io/kubespray/kubespray]="kubespray"
  )

  trimmed=$path_original
  for prefix in "${!dict[@]}"; do
    if [[ $path_original == $prefix$pattern ]]; then
      trimmed=${path_original/$prefix/${dict[$prefix]}}
      break
    fi
  done

  echo "$registry/$group/${trimmed//\//_}"
}

