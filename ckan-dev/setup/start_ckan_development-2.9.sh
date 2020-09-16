#!/bin/bash

# Initialise CKAN config

ckan generate config ${CKAN_INI}
ckan config-tool ${CKAN_INI} "ckan.plugins=${CKAN__PLUGINS}"
ckan config-tool ${CKAN_INI} "ckan.site_url=${CKAN__SITE_URL}" 

# Install any local extensions in the src_extensions volume
echo "Looking for local extensions to install..."
echo "Extension dir contents:"
ls -la $SRC_EXTENSIONS_DIR
for i in $SRC_EXTENSIONS_DIR/*
do
    if [ -d $i ] && [ $(basename $i) != 'ckan' ] && (
        [ -z "$DEV_EXTENSIONS_WHITELIST" ] || [[ ",$DEV_EXTENSIONS_WHITELIST," =~ ",$(basename $i)," ]]
    );
    then

        if [ -f $i/pip-requirements.txt ];
        then
            pip install -r $i/pip-requirements.txt
            echo "Found requirements file in $i"
        fi
        if [ -f $i/requirements.txt ];
        then
            pip install -r $i/requirements.txt
            echo "Found requirements file in $i"
        fi
        if [ -f $i/dev-requirements.txt ];
        then
            pip install -r $i/dev-requirements.txt
            echo "Found dev-requirements file in $i"
        fi
        if [ -f $i/setup.py ];
        then
            cd $i
            python $i/setup.py develop
            echo "Found setup.py file in $i"
            cd $APP_DIR
        fi

        # Point `use` in test.ini to location of `test-core.ini`
        if [ -f $i/test.ini ];
        then
            echo "Updating \`test.ini\` reference to \`test-core.ini\` for plugin $i"
            ckan config-tool $i/test.ini "use = config:../../src/ckan/test-core.ini"
        fi
    fi
done

# Set debug to true
echo "Enabling debug mode"
ckan config-tool $CKAN_INI -s DEFAULT "debug = true"

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

ckan config-tool $APP_DIR/production.ini \
  "ckan.datagovuk.s3_aws_access_key_id = $CKAN_S3_AWS_ACCESS_KEY_ID" \
  "ckan.datagovuk.s3_aws_secret_access_key = $CKAN_S3_AWS_SECRET_ACCESS_KEY" \
  "ckan.datagovuk.s3_bucket_name = $CKAN_S3_BUCKET_NAME" \
  "ckan.datagovuk.s3_url_prefix = $CKAN_S3_URL_PREFIX" \
  "ckan.datagovuk.s3_aws_region_name = $CKAN_S3_AWS_REGION_NAME"

# Run the prerun script to init CKAN and create the default admin user
python prerun.py

# Run any startup scripts provided by images extending this one
if [[ -d "/docker-entrypoint.d" ]]
then
    for f in /docker-entrypoint.d/*; do
        case "$f" in
            *.sh)     echo "$0: Running init file $f"; . "$f" ;;
            *.py)     echo "$0: Running init file $f"; python "$f"; echo ;;
            *)        echo "$0: Ignoring $f (not an sh or py file)" ;;
        esac
        echo
    done
fi

if [[ $START_CKAN = 1 ]]; then
    echo "Starting CKAN..."

    # Start supervisord
    ## commented out as ckan processes are not starting up
    ## need to manually start the processes to see what errors there are
    # supervisord --configuration /etc/supervisord.conf &

    # Start the development server with automatic reload
    ckan run --host 0.0.0.0 --reloader $CKAN_INI
else
    # just to keep container running
    echo "Keeping container running..."
    tail -f /dev/null
fi
