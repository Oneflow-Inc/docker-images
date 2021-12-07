# syntax = docker/dockerfile:experimental
# NOTE: Original from https://github.com/pytorch/pytorch/blob/master/Dockerfile
# NOTE: To build this you will need a docker version > 18.06 with
#       experimental enabled and DOCKER_BUILDKIT=1
#
#       If you do not use buildkit you are not going to have a good time
#
#       For reference:
#           https://docs.docker.com/develop/develop-images/build_enhancements/
ARG BASE_IMAGE=ubuntu:18.04
ARG PYTHON_VERSION=3.8

FROM ${BASE_IMAGE} as rdma-base

ARG D_OFED_VERSION="5.0-2.1.8.0"
ARG D_OS="ubuntu18.04"
ARG D_ARCH="x86_64"
ARG D_OFED_PATH="MLNX_OFED_LINUX-${D_OFED_VERSION}-${D_OS}-${D_ARCH}"

ARG D_OFED_TARBALL_NAME="${D_OFED_PATH}.tgz"
ARG D_OFED_BASE_URL="https://www.mellanox.com/downloads/ofed/MLNX_OFED-${D_OFED_VERSION}"
ARG D_OFED_URL_PATH="${D_OFED_BASE_URL}/${D_OFED_TARBALL_NAME}"
ARG D_WITHOUT_FLAGS="--without-rshim-dkms --without-iser-dkms --without-isert-dkms --without-srp-dkms --without-kernel-mft-dkms --without-mlnx-rdma-rxe-dkms"

ARG CUDA_VERSION=11.1
ARG LLVM_VERSION=12

WORKDIR /root
RUN set -x && \
    apt-get -yq update && \
    apt-get -yq install curl perl libcap2 && \
    (curl -sL ${D_OFED_URL_PATH} | tar -xzf -) && \
    /root/${D_OFED_PATH}/mlnxofedinstall --without-neohost-backend --user-space-only --without-fw-update --force ${D_WITHOUT_FLAGS} && \
    rm -rf /tmp/MLNX_OFED_LINUX* && \
    sed -i '/ESP_OFFLOAD_LOAD=yes/c\ESP_OFFLOAD_LOAD=no' /etc/infiniband/openib.conf && \
    cp /root/${D_OFED_PATH}/docs/scripts/openibd-post-start-configure-interfaces/post-start-hook.sh /etc/infiniband/post-start-hook.sh && \
    chmod +x /etc/infiniband/post-start-hook.sh && \
    apt-get -yq install iproute2 net-tools ifupdown netplan.io openssh-server openssh-client vim wget ffmpeg libsm6 libxext6 gdb gcc g++ make && \
    rm -rf /root/${D_OFED_PATH} && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/lists/*

FROM ${BASE_IMAGE} as dev-base
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
    wget https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0-linux-x86_64.sh && \
    bash cmake-3.22.0-linux-x86_64.sh --skip-license && \
    rm cmake-3.22.0-linux-x86_64.sh

RUN /usr/sbin/update-ccache-symlinks
RUN mkdir /opt/ccache && ccache --set-config=cache_dir=/opt/ccache
ENV PATH /opt/conda/bin:$PATH

FROM dev-base as conda
ARG PYTHON_VERSION=3.8
ARG PYTHON_VERSION=3.8
RUN curl -fsSL -v -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y python=${PYTHON_VERSION} && \
    /opt/conda/bin/conda clean -ya

FROM conda as devcontainer-cuda
WORKDIR /workspace
RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    ninja-build libopenblas-dev nasm g++ gcc autoconf libtool lsb-release software-properties-common \
    gpg-agent && \
    rm -rf /var/lib/apt/lists/* && \
    conda install -c nvidia python=${PYTHON_VERSION} "cudatoolkit=${CUDA_VERSION}" cudnn && \
    /opt/conda/bin/conda clean -ya

FROM conda as devcontainer-llvm
WORKDIR /workspace
RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    ninja-build libopenblas-dev nasm g++ gcc autoconf libtool lsb-release software-properties-common \
    gpg-agent && \
    wget https://apt.llvm.org/llvm.sh &&  \
    chmod +x llvm.sh &&  \
    ./llvm.sh 12 && \
    rm llvm.sh &&  \
    rm -rf /var/lib/apt/lists/* && \
    conda install python=${PYTHON_VERSION} && \
    /opt/conda/bin/conda clean -ya

ENV PATH /opt/conda/bin:$PATH
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

FROM conda as conda-installs
ARG CUDA_CHANNEL=nvidia
ENV CONDA_OVERRIDE_CUDA=${CUDA_VERSION}
ARG ONEFLOW_PIP_INDEX=https://staging.oneflow.info/branch/master/cu111
ARG ONEFLOW_PACKAGE_NAME=oneflow
RUN /opt/conda/bin/conda install -c "${CUDA_CHANNEL}" -y python=${PYTHON_VERSION} "cudatoolkit=${CUDA_VERSION}" && \
    /opt/conda/bin/conda clean -ya
RUN /opt/conda/bin/pip install install -f ${ONEFLOW_PIP_INDEX} ${ONEFLOW_PACKAGE_NAME}


FROM rdma-base as official
LABEL com.nvidia.volumes.needed="nvidia_driver"
RUN --mount=type=cache,id=apt-final,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libjpeg-dev \
    libpng-dev && \
    rm -rf /var/lib/apt/lists/*
COPY --from=conda-installs /opt/conda /opt/conda
ENV PATH /opt/conda/bin:$PATH
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

WORKDIR /workspace
