ARG VARIANT=noble
ARG TARGETPLATFORM

FROM --platform=${TARGETPLATFORM} buildpack-deps:${VARIANT}-curl
# FROM --platform=${TARGETPLATFORM} mcr.microsoft.com/devcontainers/base:${VARIANT}
USER root

ARG MOUNTPATH=/docker_data
ARG USERNAME=root
ARG TARGETPLATFORM

COPY .docker/base-scripts/*.sh .docker/patch/*.patch /tmp/

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && chmod u+x /tmp/*.sh && /tmp/install_common.sh && /tmp/install_xmake.sh ${USERNAME}\
    && apt-get -y install build-essential cmake clang llvm \
    && apt-get -y install lldb --no-install-recommends\
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
    # && apt-get -y install autoconf automake libtool m4 autoconf-archive \

ENV VCPKG_ROOT=/usr/local/vcpkg \
    VCPKG_DOWNLOADS=${MOUNTPATH}/share/vcpkg/downloads \
    VCPKG_DEFAULT_BINARY_CACHE=${MOUNTPATH}/share/vcpkg/cache \
    XMAKE_GLOBALDIR=${MOUNTPATH}/share \
    CONDA_DIR=/usr/local/miniforge3 \
    MOUNTPATH=${MOUNTPATH} \
    CC=/usr/bin/clang \
    CXX=/usr/bin/clang++
ENV PATH="/root/.local/bin:${CONDA_DIR}/bin:${VCPKG_ROOT}:${PATH}"

# Install vcpkg itself: https://github.com/microsoft/vcpkg/blob/master/README.md#quick-start-unix
# COPY .docker/base-scripts/*.sh .docker/patch/*.patch /tmp/
# && /tmp/install_xmake.sh ${USERNAME} \

RUN chmod +x /tmp/*.sh \
    && /tmp/install_miniforge.sh ${USERNAME}\
    && /tmp/install_vcpkg.sh  ${USERNAME} \
    && apt-get autoremove -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*