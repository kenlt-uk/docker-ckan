FROM govuk/ckan-main:2.9

MAINTAINER Data Gov UK <team@data.gov.uk >

RUN pip install remote-pdb

COPY docker-entrypoint.d/* /docker-entrypoint.d/

EXPOSE 3000

ARG DISABLE_CRON
ENV DISABLE_CRON=$DISABLE_CRON

ARG START_CKAN
ENV START_CKAN=$START_CKAN
