#!/usr/bin/env bash

# Default git fork
CKAN_FORK=ckan
DATAGOVUK_BRANCH=main
DCAT_FORK=ckan
DCAT_BRANCH=master
SPATIAL_BRANCH=master
HARVEST_FORK=ckan
HARVEST_BRANCH=master

if [[ ! -z $1 && $1 == '2.7' ]]; then
    CKAN_VERSION=2.7.6
    SRC_DIR=2.7
    DATAGOVUK_BRANCH=ckan-2.7
elif [[ ! -z $1 && $1 == '2.9' ]]; then
    DATAGOVUK_BRANCH=master-2.9
    HARVEST_FORK=alphagov
    HARVEST_BRANCH=master
    SPATIAL_FORK=alphagov
    SPATIAL_BRANCH=main-2.9
    CKAN_VERSION=2.9.2
    CKAN_FORK=ckan
    SRC_DIR=2.9
    DCAT_FORK=alphagov
    DCAT_BRANCH=update-requirements-rdflib-jsonld
else
    CKAN_VERSION=2.8.3-dgu
    CKAN_FORK=alphagov
    SRC_DIR=2.8
fi

echo -e "Please ensure that the ${SRC_DIR} src directory is empty before running this command. This command will not populate the directories required for this project to run effectively unless said directories are already empty or don't exist.\n"

mkdir -p src/$SRC_DIR
pushd src/$SRC_DIR
git clone https://github.com/$CKAN_FORK/ckan --branch ckan-$CKAN_VERSION

git clone https://github.com/alphagov/ckanext-datagovuk --branch $DATAGOVUK_BRANCH 
git clone https://github.com/$HARVEST_FORK/ckanext-harvest --branch $HARVEST_BRANCH
git clone https://github.com/$SPATIAL_FORK/ckanext-spatial --branch $SPATIAL_BRANCH
git clone https://github.com/$DCAT_FORK/ckanext-dcat --branch $DCAT_BRANCH
git clone https://github.com/geopython/pycsw.git --branch 2.4.0 

git clone https://github.com/alphagov/ckan-mock-harvest-sources.git
# appending this should quietly override any prior settings of the variable
echo $'\nmap $host $mock_absolute_root_url { default "http://static-mock-harvest-source:11088/"; }' >> ckan-mock-harvest-sources/static/vars.conf

if [[ ! -z $2 && $2 == 'full' ]]; then
    git clone https://github.com/alphagov/datagovuk_publish.git
    git clone https://github.com/alphagov/datagovuk_find.git
fi
popd
