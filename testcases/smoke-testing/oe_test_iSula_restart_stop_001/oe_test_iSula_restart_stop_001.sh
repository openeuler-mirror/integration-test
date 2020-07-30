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
# @CaseName  :   oe_test_iSula_restart_stop_001
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-09
# @License   :   Mulan PSL v2
# @Desc      :   restart and stop container
# ############################################

source ${OET_PATH}/testcases/smoke-testing/common/prepare_isulad.sh
source ${OET_PATH}/libs/locallibs/common_lib.sh
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_isulad_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    run_isulad_container
    
    isula restart ${containerId} | grep ${containerId}
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containerId} | grep running
    CHECK_RESULT $?

    isula stop ${containerId} | grep ${containerId}
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containerId} | grep exited
    CHECK_RESULT $?

    isula start ${containerId}
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containerId} | grep running
    CHECK_RESULT $?

    isula kill ${containerId} | grep ${containerId}
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containerId} | grep exited
    CHECK_RESULT $?
    LOG_INFO "End of run testcase!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_isulad_env
    DNF_REMOVE "iSulad tar"
    LOG_INFO "Finish environment cleanup."
}

main $@
