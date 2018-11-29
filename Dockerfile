ARG BASE_CONTAINER=nvidia/cuda:8.0-devel-ubuntu16.04 
FROM $BASE_CONTAINER as cuda_base


WORKDIR /root
ENV DEBIAN_FRONTEND noninteractive
## setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

## install essentials
RUN apt-get update
RUN apt-get install -q -y \
    curl \
    dirmngr \
    gnupg2 \
    lsb-release \
    build-essential \
    sudo \
    autoconf 

## python base
RUN apt-get install -q -y \
	python3-dev \
	python3-pip

## ===========================
FROM jupyter_base as python_base

## python specifics
RUN pip3 install jupyter


## setup entrypoint - use to do preprocessing and such
RUN (echo '#!/bin/bash'                         &&\
echo 'printf "$(env)" 1>&2'.....................&&\
echo 'exec "$@"'                                \
) >> /entrypoint.sh && chmod +x /entrypoint.sh

ENV appuser ${USER}

#RUN groupadd -g 999 ${appuser} && \
#    useradd -r -u 999 -g ${appuser} ${appuser}
#USER ${appuser}
CMD ["bash"]
