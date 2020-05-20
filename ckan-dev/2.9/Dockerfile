FROM govuk/ckan-base:2.9

MAINTAINER Open Knowledge International <info@okfn.org>

ENV APP_DIR=/srv/app
ENV SRC_EXTENSIONS_DIR=/srv/app/src_extensions

# Install packages needed by the dev requirements
RUN apk add --no-cache libffi-dev

RUN pip install --upgrade pip

# Install CKAN dev requirements
# pip install is unable to install pytest-split-tests from dev-requirements.txt so install it manually
RUN pip install pytest-split-tests==1.0.9

RUN pip install --no-binary :all: -r https://raw.githubusercontent.com/alphagov/ckan/${GIT_BRANCH}/dev-requirements.txt

RUN pip install configparser && \
    ckan generate config ${CKAN_INI} && \
    ckan config-tool ${CKAN_INI} "ckan.plugins=${CKAN__PLUGINS}" && \
    ckan config-tool ${CKAN_INI} "ckan.site_url=${CKAN__SITE_URL}" 

    # Upgrade pylons version as the bundled version specified in requirements-py2.txt does not work
RUN pip install Pylons==1.0.3 && \
    # webob version installed is not high enough as lacks some dependencies
    pip install webob==1.8.6 && \
    # cryptography 2.9 is broken with this error message
    # ImportError: Error relocating /usr/lib/python2.7/site-packages/cryptography/hazmat/bindings/_openssl.so: RSA_get0_crt_params: symbol not found
    # so set to cryptography 2.8
    pip install cryptography==2.8

# Create folder for local extensions sources
RUN mkdir $SRC_EXTENSIONS_DIR

# create folder for logs
RUN mkdir /var/log/ckan

COPY setup/start_ckan_development-2.9.sh ${APP_DIR}/start_ckan_development.sh
COPY setup/init_config-2.9.sh ${APP_DIR}/init_config.sh

# CMD ["/srv/app/start_ckan_development.sh"]
