#!/bin/bash

echo "***** Set up Postgres POSTGIS"

paster --plugin=ckanext-spatial spatial initdb -c "$CKAN_INI"
