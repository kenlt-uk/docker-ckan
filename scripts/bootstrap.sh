#!/usr/bin/env bash

# Default git fork
CKAN_FORK=ckan
DATAGOVUK_BRANCH=master

if [[ ! -z $1 && $1 == '2.8' ]]; then
    CKAN_VERSION=2.8.3-dgu
    CKAN_FORK=alphagov
    SRC_DIR=2.8
    DATAGOVUK_BRANCH=master-2.8
elif [[ ! -z $1 && $1 == '2.9' ]]; then
    CKAN_VERSION=2.9-dgu
    CKAN_FORK=alphagov
    SRC_DIR=2.9
    DATAGOVUK_BRANCH=ckan-2.9
else
    CKAN_VERSION=2.7.6
    SRC_DIR=2.7
fi

echo -e "Please ensure that the ${SRC_DIR} src directory is empty before running this command. This command will not populate the directories required for this project to run effectively unless said directories are already empty or don't exist.\n"

mkdir -p src/$SRC_DIR
pushd src/$SRC_DIR
git clone --branch ckan-$CKAN_VERSION https://github.com/$CKAN_FORK/ckan

git clone --branch $DATAGOVUK_BRANCH https://github.com/alphagov/ckanext-datagovuk
git checkout 118515d26048fc89c6254ae18c6a0e271e14f9fc
git clone https://github.com/ckan/ckanext-harvest
git clone https://github.com/alphagov/ckanext-spatial
git clone https://github.com/ckan/ckanext-dcat
git clone https://github.com/geopython/pycsw.git --branch 2.4.0 

git clone https://github.com/alphagov/ckan-mock-harvest-sources.git
# appending this should quietly override any prior settings of the variable
echo $'\nmap $host $mock_absolute_root_url { default "http://static-mock-harvest-source:11088/"; }' >> ckan-mock-harvest-sources/static/vars.conf

if [[ ! -z $2 && $2 == 'full' ]]; then
    git clone https://github.com/alphagov/datagovuk_publish.git
    git clone https://github.com/alphagov/datagovuk_find.git
fi
popd
