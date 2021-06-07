#!/bin/bash

echo "====== Set up Data.gov.uk ======"

echo "Update datagovuk SQLAlchemy URL"
ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-datagovuk/test.ini \
    "sqlalchemy.url = $TEST_CKAN_SQLALCHEMY_URL" \
    "ckan.redis.url = $TEST_CKAN_REDIS_URL" \
    "solr_url = $TEST_CKAN_SOLR_URL"

echo "Install dev requirements"
pip install -r $SRC_EXTENSIONS_DIR/ckanext-datagovuk/dev-requirements.txt

if [ "$DGU_TEST_DATA" != "false" ]; then
    echo "Setup test data"
    ckan -c $CKAN_INI datagovuk remove-dgu-test-data
    ckan -c $CKAN_INI datagovuk create-dgu-test-data
fi

