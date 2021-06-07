PGPASSWORD=ckan psql -h db -U ckan -d ckan_test -c "DROP EXTENSION IF EXISTS postgis CASCADE; DROP TYPE IF EXISTS log_level CASCADE;"
