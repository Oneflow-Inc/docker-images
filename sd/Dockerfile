ARG BASE_IMAGE
ARG ONEFLOW_DEVICE
FROM ${BASE_IMAGE}

ARG ONEFLOW_PIP_INDEX
ARG ONEFLOW_PACKAGE_NAME=oneflow
RUN pip install -f ${ONEFLOW_PIP_INDEX} ${ONEFLOW_PACKAGE_NAME}
ADD diffusers /src/diffusers
ADD transformers /src/transformers
RUN pip install -e /src/diffusers[oneflow] && pip install -e /src/transformers
RUN mkdir /demos
COPY ./oneflow-t2i.py /demos
