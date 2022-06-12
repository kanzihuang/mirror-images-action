# Container image that runs your code
FROM alpine

RUN apk add --no-cache \
  bash \
  skopeo

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh copy-image.sh  /
COPY mirror.d /mirror.d

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
