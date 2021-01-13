FROM ubuntu:trusty

RUN apt-get update && \ 
  apt-get install -y software-properties-common libpq-dev libsqlite3-dev && \
  apt-get update

RUN sudo add-apt-repository 'deb https://apt.publishing.service.gov.uk/govuk-python stable main' && \
    apt-get update && \
    apt-get install -y govuk-python=3.6.12 --force-yes && \
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get -y install \
      python3-setuptools && \
      easy_install3 pip
