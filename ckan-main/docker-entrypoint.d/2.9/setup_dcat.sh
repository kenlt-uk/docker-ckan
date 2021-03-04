#!/bin/bash

echo "====== Set up Dcat ======"

echo "Loading test settings into dcat test-core.ini"
ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-dcat/test.ini \
    "use = config:$SRC_DIR/ckan/test-core.ini"

echo "Update Dcat Solr URL"
ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-dcat/test.ini \
    "solr_url = $TEST_CKAN_SOLR_URL"
