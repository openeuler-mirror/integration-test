#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   oe_test_basic_query_cpu
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2021.04-09
# @License   :   Mulan PSL v2
# @Desc      :   Query CPU configure test-lscpu
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start executing testcase!"
    lscpu
    CHECK_RESULT $?

    lscpu | grep "^CPU(s)" | grep -E '[0-9]'
    CHECK_RESULT $?

    lscpu | grep "Vendor ID"
    CHECK_RESULT $?

    lshw -c cpu | grep "capacity" | grep "Hz"
    CHECK_RESULT $?

    if [ "$(uname -i)"x == "aarch64"x ]; then
        grep "0x48" /proc/cpuinfo
        CHECK_RESULT $?
    else
        cat /proc/cpuinfo | grep $(lscpu | grep "Vendor ID" | awk -F " " '{print$3}')
        CHECK_RESULT $?
    fi
    LOG_INFO "End fo test result detection!"
}

main $@
