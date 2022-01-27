ARG BASE_IMAGE=nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
FROM ${BASE_IMAGE}
ARG LLVM_VERSION=13
ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    ninja-build libopenblas-dev nasm g++ gcc autoconf automake libtool lsb-release software-properties-common \
    gpg-agent && \
    wget https://apt.llvm.org/llvm.sh &&  \
    chmod +x llvm.sh &&  \
    ./llvm.sh ${LLVM_VERSION} && \
    apt install -y libomp-${LLVM_VERSION}-dev && \
    rm llvm.sh &&  \
    rm -rf /var/lib/apt/lists/*
