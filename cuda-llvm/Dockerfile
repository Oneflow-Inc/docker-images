ARG BASE_IMAGE=nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04

FROM ${BASE_IMAGE} as dev-base

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

FROM dev-base as devcontainer-llvm
ARG LLVM_VERSION=13
WORKDIR /workspace
RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    python3-pip python3-dev python3-setuptools python3-wheel ninja-build libopenblas-dev nasm g++ gcc autoconf automake libtool lsb-release software-properties-common \
    gpg-agent && \
    wget https://apt.llvm.org/llvm.sh &&  \
    chmod +x llvm.sh &&  \
    ./llvm.sh ${LLVM_VERSION} && \
    apt install -y libomp-${LLVM_VERSION}-dev && \
    rm llvm.sh &&  \
    rm -rf /var/lib/apt/lists/*
