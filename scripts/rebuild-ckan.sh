#!/bin/bash

if [[ ! -z $1 && $1 == '2.8' ]]; then
    echo "=== Building CKAN 2.8 ==="
    VERSION=2.8
else
    echo "=== Building CKAN 2.7 ==="
    VERSION=2.7
fi

(cd ckan-base && docker build -t alphagov/ckan-base:$VERSION -f $VERSION/Dockerfile .)
(cd ckan-dev && docker build -t alphagov/ckan-dev:$VERSION -f $VERSION/Dockerfile .)

if [[ ! -z $1 && $1 == 's3' ]]; then

    echo "=== Building CKAN 2.7 s3 ==="
    (cd ckan && docker build -t alphagov/ckan:$VERSION-s3 -f $VERSION-s3/Dockerfile.dev .)
    (cd ckan-postdev && docker build -t alphagov/ckan-postdev:$VERSION-s3 -f $VERSION-s3/Dockerfile .)

else

    (cd ckan && docker build -t alphagov/ckan:$VERSION -f $VERSION/Dockerfile.dev .)
    (cd ckan-postdev && docker build -t alphagov/ckan-postdev:$VERSION -f $VERSION/Dockerfile .)

fi

if [[ ! -z $1 && $1 == 's3' ]]; then
    docker-compose -f docker-compose-$VERSION-s3.yml build 
else 
    docker-compose -f docker-compose-$VERSION.yml build 
fi
