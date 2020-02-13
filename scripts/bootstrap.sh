#!/usr/bin/env bash

if [[ ! -z $1 && $1 == '2.8' ]]; then
    CKAN_VERSION=2.8.3
    SRC_DIR=2.8
elif [[ ! -z $1 && $1 == 's3' ]]; then
    CKAN_VERSION=2.7.6
    SRC_DIR=2.7-s3
else
    CKAN_VERSION=2.7.6
    SRC_DIR=2.7
fi

mkdir -p src/$SRC_DIR
cd src/$SRC_DIR

git clone --branch ckan-$CKAN_VERSION https://github.com/ckan/ckan

git clone https://github.com/alphagov/ckanext-datagovuk
git clone --branch dgu-fixes https://github.com/alphagov/ckanext-harvest
git clone --branch dgu-fixes https://github.com/alphagov/ckanext-spatial
git clone https://github.com/ckan/ckanext-dcat
git clone https://github.com/geopython/pycsw.git --branch 2.4.0 
