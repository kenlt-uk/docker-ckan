#!/bin/bash

echo "Set up Spatial DB"

paster --plugin=ckanext-spatial spatial initdb -c "$CKAN_INI"
