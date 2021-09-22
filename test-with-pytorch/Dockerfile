ARG PYTORCH_VERSION
ARG PIP_ARGS
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda10.2-cudnn7-runtime
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
    apt-get -yq install iproute2 net-tools ifupdown netplan.io gdb openssh-server openssh-client vim wget ffmpeg libsm6 libxext6 gdb gcc g++ make && \
    rm -rf /root/${D_OFED_PATH} && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN python3 -m pip install ${PIP_ARGS} -r requirements.txt
