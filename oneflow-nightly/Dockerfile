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

FROM ${BASE_IMAGE} as dev-base
RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    ccache \
    cmake \
    curl \
    git \
    libjpeg-dev \
    libpng-dev && \
    rm -rf /var/lib/apt/lists/*
RUN /usr/sbin/update-ccache-symlinks
RUN mkdir /opt/ccache && ccache --set-config=cache_dir=/opt/ccache
ENV PATH /opt/conda/bin:$PATH

FROM dev-base as conda
ARG PYTHON_VERSION=3.8
RUN curl -fsSL -v -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y python=${PYTHON_VERSION} && \
    /opt/conda/bin/conda clean -ya

FROM conda as conda-installs
ARG PYTHON_VERSION=3.8
ARG CUDA_VERSION=11.1
ARG CUDA_CHANNEL=nvidia
ARG INSTALL_CHANNEL=pytorch-nightly
ENV CONDA_OVERRIDE_CUDA=${CUDA_VERSION}
ARG ONEFLOW_BUILD_TYPE=cu111
RUN /opt/conda/bin/conda install -c "${CUDA_CHANNEL}" -y python=${PYTHON_VERSION} "cudatoolkit=${CUDA_VERSION}" && \
    /opt/conda/bin/conda clean -ya
RUN /opt/conda/bin/pip install install -f https://staging.oneflow.info/branch/master/${ONEFLOW_BUILD_TYPE} oneflow


FROM ${BASE_IMAGE} as official
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
