ARG BASE_IMAGE
ARG ONEFLOW_DEVICE
FROM ${BASE_IMAGE}

ARG ONEFLOW_PIP_INDEX
ARG ONEFLOW_PACKAGE_NAME=oneflow
RUN pip install -f ${ONEFLOW_PIP_INDEX} ${ONEFLOW_PACKAGE_NAME}
ADD diffusers /src/diffusers
RUN python3 -m pip install transformers>=4.26 && pip install -e /src/diffusers[oneflow]
RUN mkdir /demos
COPY ./oneflow-t2i.py /demos
