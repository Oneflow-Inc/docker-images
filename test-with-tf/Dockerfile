ARG TF_VERSION
ARG PIP_ARGS
FROM tensorflow/tensorflow:${TF_VERSION}-gpu
RUN apt update && apt install -y --no-install-recommends gdb openssh-server openssh-client vim wget ffmpeg libsm6 libxext6 gdb gcc g++ make
RUN echo 'ALL ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt
