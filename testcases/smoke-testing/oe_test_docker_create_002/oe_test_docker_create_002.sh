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
# @CaseName  :   oe_test_docker_create_002
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Creating an interactive container
# ############################################

source ${OET_PATH}/testcases/smoke-testing/common/prepare_docker.sh
source ${OET_PATH}/libs/locallibs/common_lib.sh
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
    expect -c "
    log_file testlog
    spawn docker run -it ${Images_name} /bin/sh
    expect {
    \"*#*\" {send \"ls\r\"
    expect  \"*#*\" {send \"pwd\r\"}
    expect  \"*#*\" {send \"exit\r\"}
}
}
"
    grep -iE 'error|fail' testlog
    CHECK_RESULT $? 1
    cat testlog | grep -E 'bin|dev'
    CHECK_RESULT $?
    cat testlog | grep pwd -A 1 | tail -1 | grep -w '/'
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_docker_env
    DNF_REMOVE docker
    rm -rf testlog
    LOG_INFO "Finish environment cleanup."
}

main $@
