#!/usr/bin/bash

#copyright (c) 2020 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   common_lib
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Prepare system container environment
# ############################################

source ${OET_PATH}/conf/env.conf
source ${OET_PATH}/libs/locallibs/common_lib.sh
Images_name="openeuler-20.03-lts"
image_url="https://repo.openeuler.org/openEuler-20.03-LTS/docker_img/${FRAME}/openEuler-docker.${FRAME}.tar.xz"

function pre_system_env() {
    DNF_INSTALL "tar iSulad syscontainer-tools lxcfs lxcfs-tools"
    clean_env 1
    rm -rf /root/myrootfs
    mkdir -p /root/myrootfs/etc
    touch /root/myrootfs/etc/hostname
    test -f ../common/${Images_name}.tar || {
        wget ${image_url}
        isula load -i openEuler-docker.${FRAME}.tar.xz
        container_name=$(isula run -itd ${Images_name})
        isula export -o ../common/${Images_name}.tar ${container_name}
        clean_env 1
        rm -rf openEuler-docker.${FRAME}.tar.xz
    }
    tar -xvf ../common/${Images_name}.tar -C /root/myrootfs 2>&1 >/dev/null
}

function clean_env() {
    isula stop $(isula ps -aq)
    isula rm $(isula ps -aq)
    isula rmi $(isula images -q)
    if [ -z "$1" ]; then
        DNF_REMOVE "iSulad tar syscontainer-tools lxcfs lxcfs-tools"
        rm -rf /root/myrootfs
    fi
}
