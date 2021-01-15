#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
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

function pre_isulad_env() {
    DNF_INSTALL "iSulad tar"
    clean_isulad_env
    test -f ../common/openEuler-docker."$(uname -i)".tar.xz || {
        if grep 20.09 /etc/os-release; then
            os_version="openEuler-20.09"
        elif grep LTS-SP1 /etc/os-release; then
            os_version="openEuler-20.03-LTS-SP1"
        else
            os_version="openEuler-20.03-LTS"
        fi
        wget -P ../common/ https://repo.openeuler.org/${os_version}/docker_img/"$(uname -i)"/openEuler-docker."$(uname -i)".tar.xz
    }
    isula load -i ../common/openEuler-docker."$(uname -i)".tar.xz
    Images_name=$(isula images | grep latest | awk '{print$1}')
    test -n "${Images_name}" || exit 1
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
}
