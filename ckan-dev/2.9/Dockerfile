FROM govuk/ckan-base:2.9

LABEL maintainer="team@data.gov.uk"

ENV APP_DIR=/srv/app
ENV SRC_EXTENSIONS_DIR=/srv/app/src_extensions

# Install CKAN dev requirements
RUN pip install -r $SRC_DIR/ckan/dev-requirements.txt && \
    pip install pytest-ckan

# Create ckan log dir
RUN mkdir -p /var/log/ckan

# Create folder for local extensions sources
RUN mkdir $SRC_EXTENSIONS_DIR

COPY setup/start_ckan_development-2.9.sh ${APP_DIR}/start_ckan_development.sh
COPY setup/init_config-2.9.sh ${APP_DIR}/init_config.sh

# CMD ["/srv/app/start_ckan_development.sh"]
