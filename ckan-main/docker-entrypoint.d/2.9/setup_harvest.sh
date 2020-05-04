#!/bin/bash

echo "====== Set up Harvest ======"

ckanext-harvest harvester initdb -c "$CKAN_INI"

echo "Loading test settings into harvest test-core.ini"

ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-harvest/test-core.ini \
    "use = config:$SRC_DIR/ckan/test-core.ini"

echo "Loading test settings into ckan test-core.ini"
ckan config-tool $SRC_DIR/ckan/test-core.ini \
    "ckan.harvest.mq.hostname = $TEST_CKAN_REDIS_HOSTNAME"
