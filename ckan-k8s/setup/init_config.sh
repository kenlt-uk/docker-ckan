# Update the plugins setting in the ini file with the values defined in the env var
echo "Loading the following plugins: $CKAN__PLUGINS"
ckan config-tool $CKAN_INI \
    "sqlalchemy.url = $DEV_CKAN_SQLALCHEMY_URL" \
    "ckan.site_url = $DEV_CKAN_SITE_URL" \
    "solr_url = $DEV_CKAN_SOLR_URL" \
    "ckan.redis.url = $DEV_CKAN_REDIS_URL" \
    "ckan.site_url = $DEV_CKAN_SITE_URL" \
    "ckan.plugins = $CKAN__PLUGINS"

# Update test-core.ini DB, SOLR & Redis settings
echo "Loading test settings into test-core.ini"
ckan config-tool $SRC_DIR/ckan/test-core.ini \
    "sqlalchemy.url = $TEST_CKAN_SQLALCHEMY_URL" \
    "ckan.datstore.write_url = $TEST_CKAN_DATASTORE_WRITE_URL" \
    "ckan.datstore.read_url = $TEST_CKAN_DATASTORE_READ_URL" \
    "ckan.site_url = $TEST_CKAN_SITE_URL" \
    "solr_url = $TEST_CKAN_SOLR_URL" \
    "ckan.redis.url = $TEST_CKAN_REDIS_URL"

ckan config-tool $CKAN_INI \
  "ckan.datagovuk.s3_aws_access_key_id = $CKAN_S3_AWS_ACCESS_KEY_ID" \
  "ckan.datagovuk.s3_aws_secret_access_key = $CKAN_S3_AWS_SECRET_ACCESS_KEY" \
  "ckan.datagovuk.s3_bucket_name = $CKAN_S3_BUCKET_NAME" \
  "ckan.datagovuk.s3_url_prefix = $CKAN_S3_URL_PREFIX" \
  "ckan.datagovuk.s3_aws_region_name = $CKAN_S3_AWS_REGION_NAME"

# update test.ini in ckan and extensions
for i in $SRC_EXTENSIONS_DIR/*
do
    if [ -d $i ] && (
        [ -z "$DEV_EXTENSIONS_WHITELIST" ] || [[ ",$DEV_EXTENSIONS_WHITELIST," =~ ",$(basename $i)," ]]
    );
    then
        if [ -f $i/test.ini ]; then
            echo "=== Updating test config in $i"
            ckan config-tool $i/test.ini \
                "use = config:$SRC_DIR/ckan/test-core.ini" \
                "sqlalchemy.url = $TEST_CKAN_SQLALCHEMY_URL" \
                "ckan.site_url = $TEST_CKAN_SITE_URL" \
                "solr_url = $TEST_CKAN_SOLR_URL" \
                "ckan.redis.url = $TEST_CKAN_REDIS_URL"
        fi
    fi
done
