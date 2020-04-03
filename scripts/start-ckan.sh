#!/usr/bin/env bash
if [[ ! -z $1 && $1 == '2.8' ]]; then
    VERSION=2.8
elif [[ ! -z $1 && $1 == '2.9' ]]; then
    VERSION=2.9
else
    VERSION=2.7
fi

docker-compose -f docker-compose-$VERSION.yml up
