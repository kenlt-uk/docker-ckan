FROM alphagov/ckan:latest

MAINTAINER GDS <dgu@digital.cabinet-office.gov.uk>

# Set timezone
ARG TZ
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone

COPY docker-entrypoint.d/* /docker-entrypoint.d/
