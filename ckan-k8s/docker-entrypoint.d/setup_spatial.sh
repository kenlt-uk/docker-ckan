#!/bin/bash

echo "====== Set up Spatial ======"

echo "Update Spatial test ckan.site_url URL"

ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-spatial/test.ini \
    "ckan.site_url = http://localhost"

echo "Install postgis extension"

PGPASSWORD=$PSQL_PASSWD psql -h $PSQL_DB -U $PSQL_MASTER -d $CKAN_DB_NAME -c "CREATE EXTENSION postgis;"

echo "Set up Spatial database"

ckan -c "$CKAN_INI" spatial initdb