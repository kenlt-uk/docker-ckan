#!/bin/bash

echo "====== Set up Spatial database ======"

paster --plugin=ckanext-spatial spatial initdb -c "$CKAN_INI"
