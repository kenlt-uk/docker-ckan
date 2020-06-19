# FROM openknowledge/ckan-base:2.7
FROM govuk/ckan-base:2.7-0

MAINTAINER Open Knowledge Foundation <info@okfn.org>

ENV APP_DIR=/srv/app
ENV GIT_BRANCH=ckan-2.7.4
ENV SRC_EXTENSIONS_DIR=/srv/app/src_extensions

# Install packages needed by the dev requirements
RUN apk add --no-cache libffi-dev

# Install CKAN dev requirements
RUN echo $GIT_BRANCH
RUN pip install --no-binary :all: -r https://raw.githubusercontent.com/ckan/ckan/${GIT_BRANCH}/dev-requirements.txt

# cryptography 2.9 is broken with this error message
# ImportError: Error relocating /usr/lib/python2.7/site-packages/cryptography/hazmat/bindings/_openssl.so: RSA_get0_crt_params: symbol not found
# so set to cryptography 2.8
RUN pip install cryptography==2.8

# Create folder for local extensions sources
RUN mkdir $SRC_EXTENSIONS_DIR

# create folder for logs
RUN mkdir /var/log/ckan

COPY setup/start_ckan_development.sh ${APP_DIR}
COPY setup/init_config.sh ${APP_DIR}

# CMD ["/srv/app/start_ckan_development.sh"]
