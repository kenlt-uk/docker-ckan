# #!/bin/bash

echo "====== set up pycsw ======"

cd $SRC_EXTENSIONS_DIR/ckanext-spatial
ckan -c "$CKAN_INI" spatial-csw setup -p $APP_DIR/pycsw.cfg

echo "Update pycsw abstract index to allow for larger records"
PGPASSWORD=ckan psql pycsw -h db -U ckan -c "DROP INDEX ix_records_abstract;CREATE INDEX ix_records_abstract ON records((md5(abstract)));"

# run cronjob 
crond -l 2 -L /var/log/ckan/cron.log
