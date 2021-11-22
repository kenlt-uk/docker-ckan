#!/usr/bin/env bash

if [[ ! -z $1 ]]; then
  REGISTRY_PORT=$1
fi

TAG=2.9.4

if [[ ! -z $2 ]]; then
  TAG=$2
fi

docker build -t govuk/ckan-k8s-dev:$TAG -f Dockerfile.dev . --no-cache

docker tag govuk/ckan-k8s-dev:$TAG localhost:$REGISTRY_PORT/govuk/ckan-k8s-dev:$TAG

docker push localhost:$REGISTRY_PORT/govuk/ckan-k8s-dev:$TAG
