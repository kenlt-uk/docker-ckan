FROM alphagov/ckan:2.7-s3

MAINTAINER Data Gov UK <team@data.gov.uk >

RUN pip install remote-pdb

COPY docker-entrypoint.d/* /docker-entrypoint.d/

EXPOSE 3000

ARG DISABLE_CRON
ENV DISABLE_CRON=$DISABLE_CRON

ARG START_CKAN
ENV START_CKAN=$START_CKAN

# COPY setup/production-s3.ini ${APP_DIR}/production.ini
# COPY setup/start_ckan_development-s3.sh ${APP_DIR}/start_ckan_development.sh
