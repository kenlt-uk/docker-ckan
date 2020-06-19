#!/bin/bash

if [[ ! -z $1 && $1 == '2.8' ]]; then
    echo "=== Building CKAN 2.8 ==="
    VERSION=2.8
elif [[ ! -z $1 && $1 == '2.9' ]]; then
    echo "=== Building CKAN 2.9 ==="
    VERSION=2.9
elif [[ ! -z $1 && $1 == '2.7-0' ]]; then
    echo "=== Building CKAN 2.7-0 ==="
    VERSION=2.7-0
else
    echo "=== Building CKAN 2.7 ==="
    VERSION=2.7
fi

if [[ ! -z $2 && $2 == 'full' ]]; then
    echo "=== Building postdev only"
    BUILD=postdev

    echo "=== Full DGU stack"
    FULL_ARGS="-f docker-compose-$VERSION-full.yml"
elif [[ ! -z $2 && $2 == 'all' ]]; then
    echo "=== Building all CKAN projects"
    BUILD=all
elif [[ ! -z $2 && $2 == 'main' ]]; then
    echo "=== Building main and postdev"
    BUILD=main
else
    echo "=== Building postdev only"
    BUILD=postdev
fi

if [[ ! -z $3 && $3 == 'full' ]]; then
    echo "=== Full DGU stack"
    FULL_ARGS="-f docker-compose-$VERSION-full.yml"
elif [[ ! -z $2 && $2 != 'full' ]]; then
    echo "=== CKAN stack"
fi

if [[ $BUILD == 'all' || $BUILD == 'main' ]]; then

    if [[ $BUILD == 'all' ]]; then
        (cd ckan-base && docker build -t govuk/ckan-base:$VERSION -f $VERSION/Dockerfile .)
        (cd ckan-dev && docker build -t govuk/ckan-dev:$VERSION -f $VERSION/Dockerfile .)
    fi
    (cd ckan-main && docker build -t govuk/ckan-main:$VERSION -f $VERSION/Dockerfile.dev .)

fi

(cd ckan-postdev && docker build -t govuk/ckan-postdev:$VERSION -f $VERSION/Dockerfile .)

docker-compose -f docker-compose-$VERSION.yml $FULL_ARGS build
