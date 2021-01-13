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
# @CaseName  :   oe_test_docker_rename_pause_resume_001
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Rename container/pause and resume container process
# ############################################

source ../common/prepare_docker.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_docker_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    docker run -itd --name=${container_name} ${Images_name}
    CHECK_RESULT $?

    docker rename ${container_name} ${new_name}
    CHECK_RESULT $?
    docker ps -a | grep ${new_name}
    CHECK_RESULT $?
    docker ps -a | grep ${container_name}
    CHECK_RESULT $? 1

    docker pause ${new_name}
    CHECK_RESULT $?
    docker inspect -f {{.State.Status}} ${new_name} | grep paused

    docker unpause ${new_name}
    CHECK_RESULT $?
    docker inspect -f {{.State.Status}} ${new_name} | grep running
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_docker_env
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}

main $@
