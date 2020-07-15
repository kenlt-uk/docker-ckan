#!/bin/bash

if [[ ! -z $1 && $1 == '2.8' ]]; then
    echo "=== Building CKAN 2.8 ==="
    VERSION=2.8
elif [[ ! -z $1 && $1 == '2.9' ]]; then
    echo "=== Building CKAN 2.9 ==="
    VERSION=2.9
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
elif [[ ! -z $2 && $2 == 'dev' ]]; then
    echo "=== Building dev, main and postdev"
    BUILD=dev
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
    NO_CACHE=''
    if [[ ! -z $3 && $3 == 'no-cache' ]]; then
        echo "=== no cache"
        NO_CACHE="--no-cache"
    fi
fi

if [[ $BUILD == 'all' || $BUILD == 'main' || $BUILD == 'dev' ]]; then

    if [[ $BUILD == 'all' ]]; then
        (cd ckan-base && docker build $NO_CACHE -t govuk/ckan-base:$VERSION -f $VERSION/Dockerfile .)
    fi

    if [[ $BUILD == 'all' || $BUILD == 'dev' ]]; then
        (cd ckan-dev && docker build $NO_CACHE -t govuk/ckan-dev:$VERSION -f $VERSION/Dockerfile .)
    fi

    (cd ckan-main && docker build $NO_CACHE -t govuk/ckan-main:$VERSION -f $VERSION/Dockerfile.dev .)

fi

(cd ckan-postdev && docker build -t govuk/ckan-postdev:$VERSION -f $VERSION/Dockerfile .)

docker-compose -f docker-compose-$VERSION.yml $FULL_ARGS build
