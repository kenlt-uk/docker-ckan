# run harvest job to start or set job status
echo "*/5 * * * * paster --plugin=ckan harvester run -c $CKAN_INI" > /etc/crontabs/root

# clean up harvest logs
echo "*/30 * * * * paster --plugin=ckan harvester clean_harvest_log -c $CKAN_INI" >> /etc/crontabs/root

# rebuild solr index
echo "*/5 * * * * paster --plugin=ckan search-index rebuild -o -c $CKAN_INI" >> /etc/crontabs/root

# pycsw load
echo "*/5 * * * * paster --plugin=ckanext-spatial ckan-pycsw load -p $APP_DIR/pycsw.cfg -u http://localhost:5000" >> /etc/crontabs/root
