#!/bin/bash

echo "====== Set up Spatial database ======"

paster --plugin=ckanext-spatial spatial initdb -c "$CKAN_INI"

PGPASSWORD=ckan psql -h db -U ckan -d ckan_test -c "CREATE EXTENSION IF NOT EXISTS postgis;"
