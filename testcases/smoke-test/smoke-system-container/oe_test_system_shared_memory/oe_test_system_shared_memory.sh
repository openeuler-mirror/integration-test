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
# @CaseName  :   oe_test_system_shared_memory
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Shared memory channel
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
    isula run --rm -itd --host-channel /testdir:/testdir:rw:300M --system-container --external-rootfs /root/myrootfs none init
    CHECK_RESULT $?

    containers_id=$(isula ps -a | grep "init" | awk '{print$1}')
    isula inspect -f {{.State.Status}} ${containers_id} | grep running
    CHECK_RESULT $?

    dd if=/dev/zero of=/testdir/test.file bs=1M count=200
    CHECK_RESULT $?

    du -sh /testdir/test.file | grep 200M
    CHECK_RESULT $?

    isula exec -it ${containers_id} du -sh /testdir/test.file | grep 200M
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_env
    LOG_INFO "Finish environment cleanup."
}

main $@
