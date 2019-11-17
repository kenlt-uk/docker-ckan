FROM alphagov/ckan:latest

MAINTAINER GDS <dgu@digital.cabinet-office.gov.uk>

# Set timezone
ARG TZ
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone

COPY setup/setup_tests.sh ${APP_DIR}

# CMD ["/srv/app/start_tests.sh"]
