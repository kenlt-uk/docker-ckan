#!/bin/bash

echo "====== Set up Spatial ======"

echo "Update Spatial test ckan.site_url URL"

ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-spatial/test.ini \
    "ckan.site_url = http://localhost"

echo "Set up Spatial database"

ckan -c "$CKAN_INI" spatial initdb
