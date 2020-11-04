#!/bin/bash

echo "====== Set up Data.gov.uk ======"

echo "Update datagovuk SQLAlchemy URL"
ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-datagovuk/test.ini \
    "sqlalchemy.url = $TEST_CKAN_SQLALCHEMY_URL"

echo "Setup test data"
ckan -c $CKAN_INI datagovuk remove-dgu-test-data
ckan -c $CKAN_INI datagovuk create-dgu-test-data
