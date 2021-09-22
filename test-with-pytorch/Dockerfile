ARG PYTORCH_VERSION
ARG PIP_ARGS
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda10.2-cudnn7-runtime
RUN apt update && apt install -y --no-install-recommends ffmpeg libsm6 libxext6 gdb gcc g++ make vim
COPY requirements.txt .
RUN python3 -m pip install ${PIP_ARGS} -r requirements.txt
