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
# @CaseName  :   oe_test_system_rootfs_container
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Specify rootfs creation container
# ############################################

source ../common/common_lib.sh
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_system_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    isula run -tid --cgroup-parent /lxc/cgroup123 --system-container --external-rootfs /root/myrootfs none init
    CHECK_RESULT $?

    containers_id=$(isula ps -a | grep "init" | awk '{print$1}')
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containers_id} | grep running
    CHECK_RESULT $?
    num=$(isula ps -a | grep "init" | awk '{print$NF}' | awk '{print substr($0,1,2)}')
    CHECK_RESULT $?

    PID_isula=$(isula inspect -f "{{json .State.Pid}}" ${num})
    CHECK_RESULT $?

    isula inspect ${containers_id} | grep -w "Pid" | grep ${PID_isula}
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_env
    LOG_INFO "Finish environment cleanup."
}

main $@
