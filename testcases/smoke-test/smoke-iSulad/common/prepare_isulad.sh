#!/usr/bin/bash

# Copyright (c) 2020 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   prepare_isulad
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   prepare isulad
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
Images_name="busybox"
Image_address="ariq8blp.mirror.aliyuncs.com"

function pre_isulad_env() {
    DNF_INSTALL "iSulad tar"
    clean_isulad_env
    ping ${Image_address} -c 3
    if [ $? -eq 0 ];then
        sed -i "/registry-mirrors/a\"https:\/\/${Image_address}\"" /etc/isulad/daemon.json
	    systemctl restart isulad
        isula pull ${Images_name}
    else
        if [ ${FRAME} == aarch64 ];then
            isula load -i ../common/openEuler-docker.aarch64.tar.xz
        else
            isula load -i ../common/openEuler-docker.x86_64.tar.xz
        fi
        Images_name=$(isula images | grep latest | awk '{print$1}')
    fi
}

function run_isulad_container() {
    containerId=$(isula run -itd ${Images_name})
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containerId} | grep running
    CHECK_RESULT $?
}

function clean_isulad_env() {
    isula stop $(isula ps -aq)
    isula rm $(isula ps -aq)
    isula rmi $(isula images -q)
    test -z "$(isula images -q)"
    CHECK_RESULT $?
    sed -i "/${Image_address}/d" /etc/isulad/daemon.json
}
