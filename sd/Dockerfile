ARG BASE_IMAGE
ARG ONEFLOW_DEVICE
FROM ${BASE_IMAGE}

ARG ONEFLOW_PIP_INDEX
ARG ONEFLOW_PACKAGE_NAME=oneflow
RUN pip install -f ${ONEFLOW_PIP_INDEX} ${ONEFLOW_PACKAGE_NAME}
RUN git clone https://github.com/Oneflow-Inc/diffusers.git && \
    git clone  https://github.com/Oneflow-Inc/transformers.git
RUN pip install -e ./diffusers[oneflow] && pip install -e ./transformers
RUN mkdir /demos
COPY ./sd/oneflow-t2i.py /demos
