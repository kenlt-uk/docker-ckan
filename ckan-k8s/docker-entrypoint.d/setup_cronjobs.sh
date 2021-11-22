# run harvest job to start or set job status
echo "*/5 * * * * ckan -c $CKAN_INI harvester run" >> /etc/crontab

# clean up harvest logs
echo "*/30 * * * * ckan -c $CKAN_INI harvester clean-harvest-log" >> /etc/crontab

# rebuild solr index
echo "*/5 * * * * ckan -c $CKAN_INI search-index rebuild -o" >> /etc/crontab

# pycsw load
echo "*/5 * * * * ckan -c $CKAN_INI ckan-pycsw load -p $APP_DIR/pycsw.cfg -u http://localhost:5000" >> /etc/crontab
