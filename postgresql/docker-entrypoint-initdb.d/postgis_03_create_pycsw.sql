-- this needs to be run after postgis.sh script has run, hence postgis_ suffix

CREATE DATABASE pycsw TEMPLATE template_postgis OWNER ckan ENCODING 'utf-8';

-- Update pycsw abstract index to allow for larger records
DROP INDEX ix_records_abstract;CREATE INDEX ix_records_abstract ON records((md5(abstract)));
