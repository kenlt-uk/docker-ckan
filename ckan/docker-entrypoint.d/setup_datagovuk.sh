#!/bin/bash

echo "====== Set up Data.gov.uk ======"

echo "Update datagovuk SQLAlchemy URL"
paster --plugin=ckan config-tool $SRC_DIR/ckanext-datagovuk/test.ini \
    "sqlalchemy.url = $TEST_CKAN_SQLALCHEMY_URL"
