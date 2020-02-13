#!/usr/bin/env bash
if [[ ! -z $1 && $1 == '2.8' ]]; then
    VERSION=2.8
else
    VERSION=2.7
fi

if [[ ! -z $1 && $1 == 's3' ]]; then
    docker-compose -f docker-compose-$VERSION-s3.yml up
else
    docker-compose -f docker-compose-$VERSION.yml up
fi
