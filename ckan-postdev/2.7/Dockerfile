FROM alphagov/ckan:2.7

MAINTAINER Data Gov UK <team@data.gov.uk >

# Set timezone
ARG TZ
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone

RUN pip install remote-pdb

COPY docker-entrypoint.d/* /docker-entrypoint.d/

EXPOSE 3000

ARG DISABLE_CRON
ENV DISABLE_CRON=$DISABLE_CRON

ARG START_CKAN
ENV START_CKAN=$START_CKAN
