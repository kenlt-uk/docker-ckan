# Based on https://github.com/keitaroinc/docker-ckan/blob/master/images/ckan/2.9/Dockerfile
##################
### Build CKAN ###
##################
# FROM alpine:3.14.2 as ckanbuild
# FROM alpine:3.13 as ckanbuild
# FROM alpine:3.9 as ckanbuild
FROM nickgryg/alpine-pandas:3.8.10 as ckanbuild


# Used by Github Actions to tag the image with
# ENV IMAGE_TAG=2.9.4

# Set CKAN version to build
ENV GIT_URL=https://github.com/ckan/ckan.git
ENV GIT_BRANCH=ckan-2.9.4

# Set src dirs
ENV APP_DIR=/srv/app
ENV SRC_DIR=/srv/app/src
ENV PIP_SRC=${SRC_DIR}

WORKDIR ${SRC_DIR}

# Packages to build CKAN requirements and plugins
# Make sure we install python 3.8, cause CKAN is not compatible with 3.9
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
        python3=3.8.10-r0 \
        python3-dev=3.8.10-r0 && \
# RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.9/main \
        # python3=3.7.10-r0 \
        # python3-dev=3.7.10-r0 && \
        # python3=3.6.9-r3 \
        # python3-dev=3.6.9-r3 && \
    apk add --no-cache \
        git \
        curl \
        postgresql-dev \
        linux-headers \
        gcc \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        patch \
        musl-dev \
        pcre-dev \
        pcre \
        libffi-dev \
        libxml2-dev \
        libxslt-dev

# Link python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Create the src directory
RUN mkdir -p ${SRC_DIR}

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python ${SRC_DIR}/get-pip.py

# Downgrade setuptools so that CKAN requirements can be built
RUN pip install setuptools==44.1.0

# Fetch and build CKAN and requirements
RUN pip install -e git+${GIT_URL}@${GIT_BRANCH}#egg=ckan
# Copy patches and apply patches script
# COPY ./patches ${SRC_DIR}/patches
# COPY ./scripts/apply_ckan_patches.sh ${SRC_DIR}/apply_ckan_patches.sh
# Apply patches
# RUN ${SRC_DIR}/apply_ckan_patches.sh
RUN rm -rf /srv/app/src/ckan/.git
RUN pip wheel --wheel-dir=/wheels -r ckan/requirements.txt
RUN pip wheel --wheel-dir=/wheels uwsgi==2.0.19.1 gevent==21.1.2 greenlet==1.1.0


###########################
### Default-Extensions ####
###########################
# FROM alpine:3.14.2 as extbuild
# FROM alpine:3.13 as extbuild
# FROM alpine:3.9 as extbuild
FROM nickgryg/alpine-pandas:3.8.10 as extbuild

# Set src dirs
ENV SRC_DIR=/srv/app/src
ENV PIP_SRC=${SRC_DIR}

# List of default extensions
ENV DEFAULT_EXTENSIONS envvars

# Locations and tags, please use specific tags or revisions
ENV ENVVARS_GIT_URL=https://github.com/okfn/ckanext-envvars
ENV ENVVARS_GIT_BRANCH=0.0.1

# Make sure we install python 3.8, cause CKAN is not compatible with 3.9
# RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
#         python3=3.8.10-r0 \
#         python3-dev=3.8.10-r0 && \
#     apk add --no-cache \
#         git \
#         curl 
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
        python3=3.8.10-r0 \
        python3-dev=3.8.10-r0 && \
# RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.9/main \
        # python3=3.7.10-r0 \
        # python3-dev=3.7.10-r0 && \
        # python3=3.6.9-r3 \
        # python3-dev=3.6.9-r3 && \
    apk add --no-cache \
        git \
        curl \
        postgresql-dev \
        linux-headers \
        gcc \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        patch \
        musl-dev \
        pcre-dev \
        pcre \
        libffi-dev \
        libxml2-dev \
        libxslt-dev

# Link python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Create the src directory
RUN mkdir -p ${SRC_DIR}

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python ${SRC_DIR}/get-pip.py

# Fetch and build the default CKAN extensions
RUN pip wheel --wheel-dir=/wheels git+${ENVVARS_GIT_URL}@${ENVVARS_GIT_BRANCH}#egg=ckanext-envvars

############
### MAIN ###
############
# FROM alpine:3.14.2
# FROM alpine:3.13
# FROM alpine:3.9
FROM nickgryg/alpine-pandas:3.8.10

LABEL maintainer="Data.gov.uk <team@data.gov.uk>"
LABEL org.opencontainers.image.source https://github.com/keitaroinc/docker-ckan

ENV APP_DIR=/srv/app
ENV SRC_DIR=/srv/app/src
ENV CKAN_DIR=${SRC_DIR}/ckan
ENV DATA_DIR=/srv/app/data
ENV PIP_SRC=${SRC_DIR}
# ENV CKAN_SITE_URL=http://localhost:5000
ENV CKAN__PLUGINS envvars image_view text_view recline_view datastore datapusher
ENV CKAN_INI=${APP_DIR}/production.ini
ENV TEST_CKAN_INI=${SRC_DIR}/ckan/test-core.ini

# Install necessary packages to run CKAN
# Make sure we install python 3.8, cause CKAN is not compatible with 3.9
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
        python3=3.8.10-r0 && \
# RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.9/main \
        # python3=3.7.10-r0 \
        # python3-dev=3.7.10-r0 && \
        # python3=3.6.9-r3 \
        # python3-dev=3.6.9-r3 && \
    apk add --no-cache git \
        bash \
        gettext \
        curl \
        postgresql-client \
        libmagic \
        pcre \
        libxslt \
        libxml2 \
        tzdata \
        apache2-utils \
    # extra dependencies
        python3-dev=3.8.10-r0 \
        # python3-dev=3.7.10-r0 \
        # python3-dev=3.6.9-r3 \
        libc-dev \
        libffi-dev \
        geos-dev \
        proj-util \
        proj-dev \
        postgresql-libs \
        postgresql-dev \
        gcc && \
    # Create SRC_DIR
    mkdir -p ${SRC_DIR} && \
    # Link python to python3
    ln -s /usr/bin/python3 /usr/bin/python

# Install pip
RUN curl -o ${SRC_DIR}/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python ${SRC_DIR}/get-pip.py

# Get artifacts from build stages
COPY --from=ckanbuild /wheels /srv/app/wheels
COPY --from=extbuild /wheels /srv/app/ext_wheels
COPY --from=ckanbuild /srv/app/src/ckan ${CKAN_DIR}

# Additional install steps for build stages artifacts
RUN pip install --no-index --find-links=/srv/app/wheels uwsgi==2.0.19.1 gevent==21.1.2

# Create a local user and group to run the app
RUN addgroup -g 92 -S ckan && \
    adduser -u 92 -h /srv/app -H -D -S -G ckan ckan

WORKDIR ${CKAN_DIR}

# Install CKAN
RUN pip install -e /srv/app/src/ckan && \
    cp who.ini ${APP_DIR} && \
    pip install --no-index --find-links=/srv/app/wheels -r requirements.txt && \
    # Install default CKAN extensions
    pip install --no-index --find-links=/srv/app/ext_wheels ckanext-envvars && \
    # Create and update CKAN config
    # Set timezone
    echo "UTC" >  /etc/timezone && \
    # Generate CKAN config
    ckan generate config ${APP_DIR}/production.ini && \
    # Configure plugins
    ckan config-tool ${APP_DIR}/production.ini "ckan.plugins = ${CKAN__PLUGINS}" && \
    # Create the data directory
    mkdir ${DATA_DIR} && \
    # Webassets can't be loaded from env variables at runtime, it needs to be in the config so that it is created
    ckan config-tool ${APP_DIR}/production.ini "ckan.webassets.path = ${DATA_DIR}/webassets" && \
    # Set the default level for extensions to INFO
    ckan config-tool ${APP_DIR}/production.ini -s logger_ckanext -e level=INFO && \
    # Change ownership to app user
    chown -R ckan:ckan /srv/app

# Setup supervisord

COPY setup/supervisord.conf /etc
COPY setup/supervisord.d/ckan_harvesting.conf /etc/supervisord.d/ckan_harvesting.conf
COPY setup/supervisord.d/supervisor.worker.conf /etc/supervisord.d/worker.conf

RUN mkdir -p /etc/supervisord.d && \
    pip install supervisor

# Install extensions

ENV DCAT_SHA=be3b809fa7431c8d81508c01853e81ce6a5dfd84
ENV HARVEST_SHA=283ac0498fd22056fb8572d49b25cd8492b7178f
ENV SPATIAL_SHA=3f423de1e9e4e6975725712626d904887779b408
ENV DATAGOVUK_VERSION=main

RUN pip install pyOpenSSL pika

RUN pip install -e git+https://github.com/alphagov/ckanext-dcat.git@$DCAT_SHA#egg=ckanext-dcat && \
    pip install -r https://raw.githubusercontent.com/alphagov/ckanext-dcat/$DCAT_SHA/requirements.txt && \
    pip install -e git+https://github.com/alphagov/ckanext-harvest.git@$HARVEST_SHA#egg=ckanext-harvest  # && \
    pip install -r https://raw.githubusercontent.com/alphagov/ckanext-harvest/$HARVEST_SHA/pip-requirements.txt

RUN pip install -e git+https://github.com/alphagov/ckanext-spatial.git@$SPATIAL_SHA#egg=ckanext-spatial && \
    pip install -r https://raw.githubusercontent.com/alphagov/ckanext-spatial/$SPATIAL_SHA/pip3-requirements.txt && \
    pip install -e git://github.com/alphagov/ckanext-datagovuk.git@$DATAGOVUK_VERSION#egg=ckanext-datagovuk && \
    pip install -r https://raw.githubusercontent.com/alphagov/ckanext-datagovuk/$DATAGOVUK_VERSION/requirements.txt

# To enable running of ckan run-test
RUN pip install -r ${SRC_DIR}/ckan/dev-requirements.txt

# Setup pycsw
COPY setup/pycsw.cfg $APP_DIR/pycsw.cfg
COPY setup/pycsw_supervisord.conf /etc/supervisord.d/pycsw_supervisord.conf

ENV PYCSW_CONFIG=$APP_DIR/pycsw.cfg 

RUN cd $SRC_EXTENSIONS_DIR && git clone --branch 2.4.0 https://github.com/geopython/pycsw.git && \
    cd pycsw && \
    pip install -e . && \
    python setup.py build && \
    python setup.py install && \
    chown ckan $APP_DIR/pycsw.cfg && \
    chmod 644 $APP_DIR/pycsw.cfg

# Remove wheels
RUN rm -rf /srv/app/wheels /srv/app/ext_wheels

# Copy necessary scripts
COPY setup ${APP_DIR}
RUN chown ckan:ckan -R /srv/app
RUN chown ckan:ckan -R /var/lib

WORKDIR ${APP_DIR}

# Create entrypoint directory for children image scripts
ONBUILD RUN mkdir docker-entrypoint.d

COPY docker-entrypoint.d/* /docker-entrypoint.d/

# Create afterinit directory for children image scripts
ONBUILD RUN mkdir docker-afterinit.d

EXPOSE 5000

HEALTHCHECK --interval=10s --timeout=5s --retries=5 CMD curl --fail http://localhost:5000/api/3/action/status_show || exit 1

USER ckan

ENV SRC_EXTENSIONS_DIR=${APP_DIR}/src_extensions

ARG DISABLE_CRON
ENV DISABLE_CRON=$DISABLE_CRON

ARG START_CKAN
ENV START_CKAN=$START_CKAN

CMD ["/srv/app/start_ckan_development.sh"]

# CMD ["tail -f /dev/null"]