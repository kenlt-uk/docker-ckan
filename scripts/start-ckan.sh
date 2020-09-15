#!/usr/bin/env bash
if [[ ! -z $1 && $1 == '2.7' ]]; then
    VERSION=2.7
elif [[ ! -z $1 && $1 == '2.9' ]]; then
    VERSION=2.9
else
    VERSION=2.8
fi

if [[ ! -z $2 && $2 == 'full' ]]; then
    echo "=== Full DGU stack"
    FULL_ARGS="-f docker-compose-$VERSION-full.yml"
else
    echo "=== CKAN stack"
fi

docker-compose -f docker-compose-$VERSION.yml $FULL_ARGS up
