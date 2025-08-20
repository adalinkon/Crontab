#!/bin/bash
USERNAME=${1:-"root"}
wget --no-hsts --quiet  https://xmake.io/shget.text -O /tmp/xmake.sh
/bin/bash /tmp/xmake.sh
if [[ "$USERNAME" == "root" ]];then
  echo "export XMAKE_ROOT=y">> /root/.bashrc
fi