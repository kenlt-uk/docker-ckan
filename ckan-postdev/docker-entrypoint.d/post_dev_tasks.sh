# Add post dev tasks such as changing config settings, these should be moved to 
# the ckan project so that this file can be used to test out development of new features

echo "================ post dev tasks ================"

if [ $DISABLE_CRON = 1 ]; then
    echo "Stopping cronjobs from running..."
    crontab -l > cron_backup.txt
    crontab -r

    echo "*** Restore cronjobs with this command"
    echo "crontab cron_backup.txt"
fi

# Example for changing test config setting
# echo "Loading test settings into ckan test-core.ini"
# paster --plugin=ckan config-tool $SRC_DIR/ckan/test-core.ini \
#     "ckan.harvest.mq.hostname = $TEST_CKAN_REDIS_HOSTNAME"

paster --plugin=ckan config-tool $APP_DIR/production.ini "ckan.datagovuk.s3_aws_access_key_id = $CKAN_S3_AWS_ACCESS_KEY_ID"
paster --plugin=ckan config-tool $APP_DIR/production.ini "ckan.datagovuk.s3_aws_secret_access_key = $CKAN_S3_AWS_SECRET_ACCESS_KEY"
paster --plugin=ckan config-tool $APP_DIR/production.ini "ckan.datagovuk.s3_bucket_name = $CKAN_S3_BUCKET_NAME"
paster --plugin=ckan config-tool $APP_DIR/production.ini "ckan.datagovuk.s3_url_prefix = $CKAN_S3_URL_PREFIX"
paster --plugin=ckan config-tool $APP_DIR/production.ini "ckan.datagovuk.s3_aws_region_name = $CKAN_S3_AWS_REGION_NAME"
