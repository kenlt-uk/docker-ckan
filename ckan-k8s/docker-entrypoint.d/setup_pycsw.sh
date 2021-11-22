# #!/bin/bash

echo "====== set up pycsw ======"

cd $SRC_EXTENSIONS_DIR/ckanext-spatial
ckan -c "$CKAN_INI" ckan-pycsw setup -p $APP_DIR/pycsw.cfg

echo "Update pycsw abstract index to allow for larger records"
PGPASSWORD=$PSQL_PASSWD psql -h $PSQL_DB -U $PSQL_MASTER -d pycsw -c "DROP INDEX ix_records_abstract;CREATE INDEX ix_records_abstract ON records((md5(abstract)));"

# run cronjob 
crond -l 2 -L /var/log/ckan/cron.log

# turn db logging on 

# ALTER DATABASE ckan_default SET log_statement = 'all';

# ALTER DATABASE ckan_default SET logging_collector = 'on';