# Update test-core.ini in harvest

echo "Loading test settings into harvest test-core.ini"
paster --plugin=ckan config-tool $SRC_EXTENSIONS_DIR/ckanext-harvest/test-core.ini \
    "ckan.harvest.mq.hostname = $TEST_CKAN_REDIS_HOSTNAME"
