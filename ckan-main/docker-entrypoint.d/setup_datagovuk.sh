#!/bin/bash

echo "====== Set up Data.gov.uk ======"

echo "Update datagovuk SQLAlchemy URL"
paster --plugin=ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-datagovuk/test.ini \
    "sqlalchemy.url = $TEST_CKAN_SQLALCHEMY_URL"

echo "Setup test data"
paster --plugin=ckanext-datagovuk remove_dgu_test_data -c $CKAN_INI
paster --plugin=ckanext-datagovuk create_dgu_test_data -c $CKAN_INI
