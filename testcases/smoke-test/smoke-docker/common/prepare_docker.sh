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
Images_name="busybox"
Image_address="ariq8blp.mirror.aliyuncs.com"

function pre_docker_env() {
    DNF_INSTALL docker
    ping ${Image_address} -c 3
    if [ $? -ne 0 ]; then
        clean_docker_env
        if [ ${FRAME} == aarch64 ]; then
            docker load -i ../common/openEuler-docker.aarch64.tar.xz
        else
            docker load -i ../common/openEuler-docker.x86_64.tar.xz
        fi
        Images_name=$(docker images | grep latest | awk '{print$1}')
    else
        docker pull ${Images_name}
    fi
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
