#!/bin/bash

echo "====== Set up Spatial database ======"

ckan -c "$CKAN_INI" spatial initdb

PGPASSWORD=ckan psql -h db -U ckan -d ckan_test -c "CREATE EXTENSION IF NOT EXISTS postgis;"
