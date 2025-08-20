ARG VARIANT=ubuntu-24.04
ARG TARGETPLATFORM

FROM --platform=${TARGETPLATFORM} mcr.microsoft.com/devcontainers/base:${VARIANT}
USER root

ARG MOUNTPATH=/docker_data
ARG USERNAME=root
ARG TARGETPLATFORM

# Install needed packages. Use a separate RUN statement to add your own dependencies.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install build-essential cmake cppcheck valgrind clang lldb llvm gdb \
    # && apt-get -y install autoconf automake libtool m4 autoconf-archive \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV VCPKG_ROOT=/usr/local/vcpkg \
    VCPKG_DOWNLOADS=${MOUNTPATH}/buildcache/vcpkg/downloads \
    VCPKG_DEFAULT_BINARY_CACHE=${MOUNTPATH}/buildcache/vcpkg/cache \
    XMAKE_GLOBALDIR=${MOUNTPATH}/buildcache \
    CONDA_DIR=${MOUNTPATH}/${TARGETPLATFORM}/miniforge3/
ENV PATH="${CONDA_DIR}/bin:${VCPKG_ROOT}:${PATH}"

# Install vcpkg itself: https://github.com/microsoft/vcpkg/blob/master/README.md#quick-start-unix
COPY .docker/base-scripts/*.sh .docker/patch/*.patch /tmp/
RUN chmod u+x /tmp/*.sh \ 
    && ./tmp/install_vcpkg.sh  ${USERNAME} \
    && ./tmp/install_xmake.sh ${USERNAME} \
    && ./tmp/install_miniforge.sh ${USERNAME}\
    && rm -f /tmp/*
# && if [[ $USECONDA == 1 ]]; then ./tmp/install_miniforge.sh; fi \

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>