#!/bin/bash

#./docker_build.bash $(cat VERSION)

client_tag="${1:?no version tag given for client}"

tagAndPush() {
  docker tag "$1" "$2"
  docker push "$2"
}

if docker pull mjuul/ld-client:"$client_tag" >&- 2>&-; then
  docker build --build-arg VERSION="$client_tag" -t ld-client -f dockerfiles/Dockerfile_client .

  if tagAndPush ld-client mjuul/ld-client:"$client_tag"; then
    echo "pushed ld-client:$client_tag to docker-hub"
  fi

  if tagAndPush ld-client mjuul/ld-client:latest; then
    echo "pushed ld-client:latest to docker-hub"
  fi

  docker build -t ldwclient -f dockerfiles/Dockerfile_ldwclient .
else
  echo "nothing built"
  exit 1
fi

