ARG BASE_IMAGE=nvidia/cuda:11.2.2-cudnn8-devel-centos7
FROM ${BASE_IMAGE}
ARG BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/3.4.1/bazel-3.4.1-linux-x86_64"
LABEL maintainer="OneFlow Maintainers"

# manylinux2014
ENV AUDITWHEEL_ARCH x86_64
ENV AUDITWHEEL_PLAT manylinux2014_$AUDITWHEEL_ARCH
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV PATH $PATH:/usr/local/bin
ENV LD_LIBRARY_PATH /usr/local/lib64:/usr/local/lib
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

ARG MANYLINUX_SHA=99194b01f31f4e84853a83b77b4fccde8f6b1642
RUN yum -y install unzip && curl -L -o manylinux.zip https://github.com/pypa/manylinux/archive/${MANYLINUX_SHA}.zip && unzip manylinux.zip -d tmp && cp -r tmp/*/docker/build_scripts /build_scripts && bash build_scripts/build.sh && rm -r build_scripts tmp manylinux.zip

ENV SSL_CERT_FILE=/opt/_internal/certs.pem
# manylinux2014 end

RUN yum-config-manager --add-repo https://yum.repos.intel.com/oneapi && \
    rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    yum update -y && yum install -y epel-release && \
    yum -y install centos-release-scl && \
    yum install -y intel-oneapi-mkl-devel-2021.2.0 nasm rdma-core-devel devtoolset-7-gcc* rsync gdb ccache ninja-build

RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0-linux-x86_64.sh && \
    bash cmake-3.22.0-linux-x86_64.sh --skip-license && \
    rm cmake-3.22.0-linux-x86_64.sh

RUN mkdir -p /tmp && cd /tmp && \
    curl -L -o patchelf-src.zip \
    https://github.com/Oneflow-Inc/patchelf/archive/64bf5388ef7d45d3697c4aadbd3f5d7d68a22aa3.zip && \
    unzip patchelf-src.zip && cd patchelf-* && ./bootstrap.sh && ./configure && make -j`nproc` && \
    make install && cd .. && rm -rf patchelf-*

RUN curl -L $BAZEL_URL -o /usr/local/bin/bazel \
    && chmod +x /usr/local/bin/bazel \
    && bazel
