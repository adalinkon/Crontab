#!/bin/bash
echo "running install_common.sh"
package_list="git neovim sudo gnupg2 bash-completion curl wget locales lsof ca-certificates \
    unzip bzip2 xz-utils zip zlib1g tar \
    apt-transport-https dirmngr psmisc procps apt-utils\
    libstdc++6 libc6 libicu[0-9][0-9] libgcc1 pkg-config ninja-build\
    openssh-server aria2 \
    lsb-release zlib1g-dev"

# Include libssl1.1 if available
if [[ ! -z $(apt-cache --names-only search ^libssl1.1$) ]]; then
    package_list="${package_list} libssl1.1"
fi
# Include libssl3 if available
if [[ ! -z $(apt-cache --names-only search ^libssl3$) ]]; then
    package_list="${package_list} libssl3"
fi

export DEBIAN_FRONTEND=noninteractive
# apt-get update -y
apt-get -y install --no-install-recommends ${package_list}
apt-get -y upgrade --no-install-recommends