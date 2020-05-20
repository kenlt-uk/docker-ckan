#!/usr/bin/env bash

if [[ ! -z $1 && $1 == '2.8' ]]; then
    VERSION=-2.8
elif [[ ! -z $1 && $1 == '2.9' ]]; then
    VERSION=-2.9
fi

if [[ ! -z $2 && $2 == 'full' ]]; then
    docker volume rm docker-ckan_es_data$VERSION
fi

docker volume rm docker-ckan_ckan_storage$VERSION
docker volume rm docker-ckan_solr_data$VERSION
docker volume rm docker-ckan_pg_data$VERSION
