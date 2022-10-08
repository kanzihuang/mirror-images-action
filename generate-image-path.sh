#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "Usage: $(basename $0) <registry-host> <image-source>"
  exit 1
fi

docker_io_account="kanzihuang"
registry_host=$1
image_source=$2

declare -A repositories=(
  # gcr and kubernetes image repo define
  # [gcr_image_repo]="gcr.io"
  [kube_image_repo]="registry.k8s.io"
  [k8s_image_repo]="registry.k8s.io"

  # docker image repo define
  [docker_image_repo]="docker.io"

  # quay image repo define
  [quay_image_repo]="quay.io"

  # github image repo define (ex multus only use that)
  [github_image_repo]="ghcr.io"

  # Private Container Image Registry
  [registry_host]="$registry_host"
)

declare mapping="
  {{ quay_image_repo }}/kubespray/kubespray,{{ registry_host }}/kubespray
  {{ kube_image_repo }}/kube-apiserver,{{ registry_host }}/kube-apiserver
  {{ kube_image_repo }}/kube-controller-manager,{{ registry_host }}/kube-controller-manager
  {{ kube_image_repo }}/kube-scheduler,{{ registry_host }}/kube-scheduler
  {{ kube_image_repo }}/kube-proxy,{{ registry_host }}/kube-proxy

  {{ docker_image_repo }}/library,{{ registry_host }}
  {{ docker_image_repo }}/${docker_io_account},{{ registry_host }}

  {{ docker_image_repo }},{{ registry_host }}

  {{ kube_image_repo }},{{ registry_host }}/{{ k8s_image_repo }}
  {{ k8s_image_repo }},{{ registry_host }}/{{ k8s_image_repo }}
  {{ gcr_image_repo }},{{ registry_host }}/{{ gcr_image_repo }}
  {{ github_image_repo }},{{ registry_host }}/{{ github_image_repo }}
  {{ quay_image_repo }},{{ registry_host }}/{{ quay_image_repo }}
"

expr1="/^\s*$/d; s@^\s*@@p; "
for key in "${!repositories[@]}"; do
  expr1+="s@[{]+\s$key\s[}]+@${repositories[$key]}@g; "
done
expr1+="p; "

expr2=""
while IFS=',' read key value; do
  expr2+="\@$key@{s@$key@$value@p;q}; "
done <<< $(echo "$mapping" | sed -n -r -e "$expr1")
expr2+="s@.*@${registry_host}/\0@p"

slash_count="$(( 4-$(echo ${registry_host} | sed 's@[^/]@@g' | wc -c) ))"
echo "$image_source" | sed -n -e "$expr2" | sed -e "/{{\s*registry_host\s*}}/b END; s@/@_@g3;q; :END s@/@_@g${slash_count};q"
