ARG BASE_IMAGE=openvino/ubuntu20_dev_no_samples

FROM ${BASE_IMAGE} as dev-base
USER root
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root
RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    ccache \
    wget \
    curl \
    git \
    libjpeg-dev \
    libpng-dev && \
    rm -rf /var/lib/apt/lists/* && \
    cd /usr/local && \
    wget https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0-linux-x86_64.sh && \
    bash cmake-3.22.0-linux-x86_64.sh --skip-license && \
    rm cmake-3.22.0-linux-x86_64.sh

RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    lld \
    python3-pip python3-dev python3-setuptools python3-wheel ninja-build libopenblas-dev nasm g++ gcc autoconf automake libtool lsb-release software-properties-common \
    gpg-agent && \
    rm -rf /var/lib/apt/lists/*
