#!/bin/bash
echo "running install_miniforge.sh"

USERNAME=${1:-"root"}

wget --no-hsts --quiet "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" -O /tmp/miniforge.sh
/bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR}
conda clean --tarballs --index-cache --packages --yes
find ${CONDA_DIR} -follow -type f -name '*.a' -delete
find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete
conda clean --force-pkgs-dirs --all --yes

user_dir="/root"
if [[ "${USERNAME}" != "root" ]];then
  user_dir="/home/${USERNAME}"
  mkdir -p "${user_dir}"
fi
echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> /etc/skel/.bashrc
echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ${user_dir}/.bashrc
cat > ${user_dir}/.condarc <<EOF
channels:
  - conda-forge
custom_channels:
  conda-forge: https://mirrors.sjtug.sjtu.edu.cn/anaconda/cloud/
show_channel_urls: true
auto_activate_base: false
pkgs_dirs:
  - ${MOUNTPATH}/share/$(uname)_$(uname -m)/miniforge3/pkgs
envs_dirs:
  - ${MOUNTPATH}/share/$(uname)_$(uname -m)/miniforge3/envs
EOF