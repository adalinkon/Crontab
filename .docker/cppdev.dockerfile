ARG VARIANT=noble
ARG TARGETPLATFORM

FROM --platform=${TARGETPLATFORM} buildpack-deps:${VARIANT}-curl
USER root

ARG MOUNTPATH=/docker_data
ARG USERNAME=root
ARG TARGETPLATFORM

COPY .docker/base-scripts/*.sh .docker/patch/*.patch /tmp/

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && chmod u+x /tmp/install_common.sh && /tmp/install_common.sh \
    && apt-get -y install build-essential cmake cppcheck valgrind clang lldb llvm gdb
    # && apt-get -y install autoconf automake libtool m4 autoconf-archive \

ENV VCPKG_ROOT=/usr/local/vcpkg \
    VCPKG_DOWNLOADS=${MOUNTPATH}/share/vcpkg/downloads \
    VCPKG_DEFAULT_BINARY_CACHE=${MOUNTPATH}/share/vcpkg/cache \
    XMAKE_GLOBALDIR=${MOUNTPATH}/share \
    CONDA_DIR=/usr/local/miniforge3 \
    MOUNTPATH=${MOUNTPATH} \
    CC=/usr/bin/clang \
    CXX=/usr/bin/clang++
ENV PATH="${CONDA_DIR}/bin:${VCPKG_ROOT}:${PATH}"

# Install vcpkg itself: https://github.com/microsoft/vcpkg/blob/master/README.md#quick-start-unix
RUN chmod u+x /tmp/*.sh \
    && ./tmp/install_vcpkg.sh  ${USERNAME} \
    && ./tmp/install_xmake.sh ${USERNAME} \
    && ./tmp/install_miniforge.sh ${USERNAME}\
    && apt-get autoremove -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* && rm -f /tmp/*
