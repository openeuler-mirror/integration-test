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
# @CaseName  :   prepare_docker
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   prepare docker
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_docker_env() {
    DNF_INSTALL docker
    clean_docker_env
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
    docker load -i ../common/openEuler-docker."$(uname -i)".tar.xz
    Images_name=$(docker images | grep latest | awk '{print$1}')
    test -n "${Images_name}" || exit 1
}

function run_docker_container() {
    containers_id=$(docker run -itd ${Images_name})
    CHECK_RESULT $?
    docker inspect -f {{.State.Status}} ${containers_id} | grep running
    CHECK_RESULT $?
}

function clean_docker_env() {
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
    docker rmi $(docker images -q)
    test -z "$(docker images -q)"
    CHECK_RESULT $?
}
