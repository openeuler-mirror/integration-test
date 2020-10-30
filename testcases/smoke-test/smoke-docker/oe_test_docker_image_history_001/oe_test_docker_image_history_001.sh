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
# @CaseName  :   oe_test_docker_image_history_001
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Display the change history of an image
# ############################################

source ../common/prepare_docker.sh
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_docker_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    images_id=$(docker images ${Images_name} -q)
    docker history ${Images_name}:latest | grep ${images_id}
    CHECK_RESULT $?

    containers_id=$(docker run -itd ${Images_name})
    docker export ${containers_id} > ${Images_name}.tar
    CHECK_RESULT $?
    test -f ${Images_name}.tar
    CHECK_RESULT $?

    clean_docker_env
    docker import ${Images_name}.tar ${Images_name}:latest
    CHECK_RESULT $?
    docker images | grep ${Images_name} | grep latest
    CHECK_RESULT $?

    docker history ${Images_name}:latest | grep -i "Imported"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    docker rmi $(docker images -q)
    DNF_REMOVE docker
    rm -rf ${Images_name}.tar
    LOG_INFO "Finish environment cleanup."
}

main $@
