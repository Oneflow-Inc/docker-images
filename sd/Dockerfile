ARG BASE_IMAGE
ARG ONEFLOW_DEVICE
FROM ${BASE_IMAGE}

ARG ONEFLOW_PIP_INDEX
ARG ONEFLOW_PACKAGE_NAME=oneflow
RUN pip install install -f ${ONEFLOW_PIP_INDEX} ${ONEFLOW_PACKAGE_NAME}
COPY diffusers .
COPY transformers .
RUN pip install -e ./diffusers[oneflow] && pip install -e ./transformers
