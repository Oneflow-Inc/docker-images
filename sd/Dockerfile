ARG BASE_IMAGE
ARG ONEFLOW_DEVICE
FROM ${BASE_IMAGE}

ARG ONEFLOW_PIP_INDEX
ARG ONEFLOW_PACKAGE_NAME=oneflow
RUN pip install install -f ${ONEFLOW_PIP_INDEX} ${ONEFLOW_PACKAGE_NAME}
ADD diffusers /oneflow-projects/diffusers
ADD transformers /oneflow-projects/transformers
RUN pip install -e ./oneflow-projects/diffusers[oneflow] && pip install -e /oneflow-projects/transformers
