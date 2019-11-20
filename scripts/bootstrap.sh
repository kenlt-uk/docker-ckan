#!/usr/bin/env bash

cd src

git clone --branch ckan-2.7.6 https://github.com/ckan/ckan

git clone https://github.com/alphagov/ckanext-datagovuk
git clone https://github.com/alphagov/ckanext-harvest
git clone --branch fix-postgis_search-solr6.2 https://github.com/alphagov/ckanext-spatial
git clone https://github.com/alphagov/ckanext-dcat
git clone https://github.com/alphagov/ckanext-s3-resources
