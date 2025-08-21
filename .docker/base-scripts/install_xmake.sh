#!/bin/bash
echo "running install_xmake.sh"
USERNAME=${1:-"root"}
# wget --no-hsts --quiet  https://xmake.io/shget.text -O /tmp/xmake.sh
# /bin/bash /tmp/xmake.sh
export DEBIAN_FRONTEND=noninteractive
apt-get -y install xmake xmake-data --no-install-recommends

user_dir="/home/${USERNAME}"
if [[ "$USERNAME" == "root" ]];then
  echo "export XMAKE_ROOT=y">> /root/.bashrc
  user_dir="/root"
fi
# ${user_dir}/.local/bin/xmake update --integrate