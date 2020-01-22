#!/usr/bin/env bash

if [[ ! -z $1 && $1 == '2.8' ]]; then
    VERSION=-2.8
fi

docker volume rm docker-ckan_ckan_storage$VERSION
docker volume rm docker-ckan_solr_data$VERSION
docker volume rm docker-ckan_pg_data$VERSION
