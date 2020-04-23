#!/bin/bash

NS=alphagov
if [[ ! -z $1 && $1 == '2.7-dh' ]]; then
    echo "=== Building CKAN 2.7 docker hub ==="
    VERSION=2.7
    NS=kentsang
elif [[ ! -z $1 && $1 == '2.8' ]]; then
    echo "=== Building CKAN 2.8 ==="
    VERSION=2.8
elif [[ ! -z $1 && $1 == '2.9' ]]; then
    echo "=== Building CKAN 2.9 ==="
    VERSION=2.9
else
    echo "=== Building CKAN 2.7 ==="
    VERSION=2.7
fi

(cd ckan-base && docker build -t $NS/ckan-base:$VERSION -f $VERSION/Dockerfile .)
(cd ckan-dev && docker build -t $NS/ckan-dev:$VERSION -f $VERSION/Dockerfile .)
(cd ckan && docker build -t $NS/ckan:$VERSION -f $VERSION/Dockerfile.dev .)
(cd ckan-postdev && docker build -t $NS/ckan-postdev:$VERSION -f $VERSION/Dockerfile .)

if [[ $NS == 'kentsang']]; then
    docker-compose -f docker-compose-2.7-dh.yml build
else
    docker-compose -f docker-compose-$VERSION.yml build
fi
