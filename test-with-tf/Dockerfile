ARG TF_VERSION
ARG PIP_ARGS
FROM tensorflow/tensorflow:${TF_VERSION}-gpu

ARG D_OFED_VERSION="5.0-2.1.8.0"
ARG D_OS="ubuntu18.04"
ARG D_ARCH="x86_64"
ARG D_OFED_PATH="MLNX_OFED_LINUX-${D_OFED_VERSION}-${D_OS}-${D_ARCH}"

ARG D_OFED_TARBALL_NAME="${D_OFED_PATH}.tgz"
ARG D_OFED_BASE_URL="https://www.mellanox.com/downloads/ofed/MLNX_OFED-${D_OFED_VERSION}"
ARG D_OFED_URL_PATH="${D_OFED_BASE_URL}/${D_OFED_TARBALL_NAME}"
ARG D_WITHOUT_FLAGS="--without-rshim-dkms --without-iser-dkms --without-isert-dkms --without-srp-dkms --without-kernel-mft-dkms --without-mlnx-rdma-rxe-dkms"

WORKDIR /root
RUN set -x && \
    apt-get -yq update && \
    apt-get -yq install curl perl && \
    (curl -sL ${D_OFED_URL_PATH} | tar -xzf -) && \
    /root/${D_OFED_PATH}/mlnxofedinstall --user-space-only --without-fw-update --force ${D_WITHOUT_FLAGS} && \
    rm -rf /tmp/MLNX_OFED_LINUX* && \
    sed -i '/ESP_OFFLOAD_LOAD=yes/c\ESP_OFFLOAD_LOAD=no' /etc/infiniband/openib.conf && \
    cp /root/${D_OFED_PATH}/docs/scripts/openibd-post-start-configure-interfaces/post-start-hook.sh /etc/infiniband/post-start-hook.sh && \
    chmod +x /etc/infiniband/post-start-hook.sh && \
    apt-get -yq install iproute2 net-tools ifupdown linux-modules-$(uname -r) netplan.io gdb openssh-server openssh-client vim wget ffmpeg libsm6 libxext6 gdb gcc g++ make && \
    rm -rf /root/${D_OFED_PATH} && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'ALL ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt
