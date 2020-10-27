FROM ubuntu:trusty

RUN apt-get update
RUN apt-get -y install libpq-dev \
        libgeos-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        wget

RUN apt-get -y install software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get -y install python3.6 \
        python3.6-dev \
        python3-setuptools \
        python3.6-venv && \
    easy_install3 pip && \
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10
