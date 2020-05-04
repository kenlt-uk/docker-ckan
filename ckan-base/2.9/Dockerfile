# FROM alpine:3.7
FROM govuk/alpine-geos

# Internals, you probably don't need to change these
ENV APP_DIR=/srv/app
ENV SRC_DIR=/srv/app/src
ENV CKAN_INI=${APP_DIR}/production.ini
ENV TEST_CKAN_INI=${SRC_DIR}/ckan/test-core.ini
ENV PIP_SRC=${SRC_DIR}
ENV CKAN_STORAGE_PATH=/var/lib/ckan
ENV GIT_URL=https://github.com/alphagov/ckan.git
# CKAN version to build
ENV GIT_BRANCH=ckan-2.9-dgu

WORKDIR ${APP_DIR}

# Install necessary packages to run CKAN
RUN apk add --no-cache tzdata \
        git \
        gettext \
        postgresql-client \
        python \
        apache2-utils \
        libxml2 \
        libxslt \
        musl-dev \
        uwsgi \
        uwsgi-http \
        uwsgi-corerouter \
        uwsgi-python \
        py2-gevent \
        uwsgi-gevent \
        libmagic \
        curl \
        vim \
        sudo && \
    # Packages to build CKAN requirements and plugins
    apk add --no-cache --virtual .build-deps \
        postgresql-dev \
        gcc \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        python-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers && \
    # Create SRC_DIR
    mkdir -p ${SRC_DIR} && \
    # Install pip, supervisord and uwsgi
    curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python ${SRC_DIR}/get-pip.py && \
    pip install supervisor && \
    mkdir /etc/supervisord.d && \
    #pip wheel --wheel-dir=/wheels uwsgi gevent && \
    rm -rf ${SRC_DIR}/get-pip.py

# RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
#     apk add --update --no-cache geos@testing geos-dev@testing

COPY setup/supervisord.conf /etc

# Install CKAN
RUN pip install -e git+${GIT_URL}@${GIT_BRANCH}#egg=ckan && \
    cd ${SRC_DIR}/ckan && \
    cp who.ini ${APP_DIR} && \
    pip install --no-binary :all: -r requirements-py2.txt && \
    # Install CKAN envvars to support loading config from environment variables
    pip install -e git+https://github.com/okfn/ckanext-envvars.git#egg=ckanext-envvars

# Create a local user and group to run the app
RUN addgroup -g 92 -S ckan && \
    adduser -u 92 -h /srv/app -H -D -S -G ckan ckan

# Create local storage folder
RUN mkdir -p $CKAN_STORAGE_PATH && \
    chown -R ckan:ckan $CKAN_STORAGE_PATH

COPY setup ${APP_DIR}
COPY setup/prerun-2.9.py ${APP_DIR}/prerun.py
COPY setup/ckan_harvesting.conf /etc/supervisord.d/ckan_harvesting.conf
COPY setup/supervisor.worker.conf /etc/supervisord.d/worker.conf
COPY setup/uwsgi.conf /srv/app/uwsgi.conf

# Create entrypoint directory for children image scripts
ONBUILD RUN mkdir /docker-entrypoint.d

RUN chown ckan -R /srv/app

HEALTHCHECK --interval=10s --timeout=5s --retries=5 CMD curl --fail http://localhost:$CKAN_PORT/api/3/action/status_show || exit 1

CMD ["/srv/app/start_ckan.sh"]
