#!/bin/bash

echo "====== Set up Dcat ======"

echo "Update Dcat Solr URL"
paster --plugin=ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-dcat/test.ini \
    "solr_url = $TEST_CKAN_SOLR_URL"
