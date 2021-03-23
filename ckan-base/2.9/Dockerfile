FROM govuk/python:3.6.12

ENV APP_DIR=/srv/app
ENV SRC_DIR=/srv/app/src
ENV CKAN_INI=${APP_DIR}/production.ini
ENV TEST_CKAN_INI=${SRC_DIR}/ckan/test-core.ini
ENV PIP_SRC=${SRC_DIR}
ENV CKAN_STORAGE_PATH=/var/lib/ckan

# Set up virtual env as part of PATH so users don't need to activate venv
ENV VIRTUAL_ENV=${APP_DIR}/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV GIT_URL=https://github.com/ckan/ckan.git
# ckan 2.9.2 release tag
ENV GIT_SHA=1b6d91790cfa668a6226f366b91dde68ae5d84b9

WORKDIR ${APP_DIR}

# Install necessary packages to run CKAN
RUN apt-get -y install tzdata \
        git \
        gettext \
        postgresql-client \
        apache2-utils \
        libxml2 \
        libxslt1.1 \
        musl-dev \
        uwsgi \
        libmagic-dev \
        curl \
        vim \
        sudo && \
    # Packages to build CKAN requirements and plugins
    sudo apt-get -y install \
        gcc \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        libxml2-dev \
        libxslt-dev \
        linux-headers-generic-lts-vivid && \
    # Create SRC_DIR
    mkdir -p ${SRC_DIR} && \
    # Install pip, supervisord and uwsgi
    mkdir /etc/supervisord.d

# Install CKAN
RUN python3.6 -m venv ${VIRTUAL_ENV} && \
    pip install supervisor && \
    pip install -e git+${GIT_URL}@${GIT_SHA}#egg=ckan && \
    cd ${SRC_DIR}/ckan && \
    cp who.ini ${APP_DIR} && \
    pip install --no-binary :all: -r requirements.txt && \
    # Install CKAN envvars to support loading config from environment variables
    pip install -e git+https://github.com/okfn/ckanext-envvars.git#egg=ckanext-envvars && \
    ckan generate config ${CKAN_INI} && \
    ckan config-tool ${CKAN_INI} "ckan.plugins=${CKAN__PLUGINS}"

COPY setup/supervisord.conf /etc

# Create a local user and group to run the app
RUN groupadd -g 92 ckan && \
    useradd -u 92 -d /srv/app -m -g ckan ckan

# Create local storage folder
RUN mkdir -p $CKAN_STORAGE_PATH && \
    chown -R ckan:ckan $CKAN_STORAGE_PATH

COPY setup ${APP_DIR}
COPY setup/2.9/prerun.py ${APP_DIR}/prerun.py
COPY setup/2.9/ckan_harvesting.conf /etc/supervisord.d/ckan_harvesting.conf
COPY setup/2.9/supervisor.worker.conf /etc/supervisord.d/worker.conf

# Create entrypoint directory for children image scripts
ONBUILD RUN mkdir /docker-entrypoint.d

RUN chown ckan -R /srv/app

HEALTHCHECK --interval=10s --timeout=5s --retries=5 CMD curl --fail http://localhost:$CKAN_PORT/api/3/action/status_show || exit 1

CMD ["/srv/app/start_ckan.sh"]
