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
# @CaseName  :   oe_test_basic_system_info
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2021.04-28
# @License   :   Mulan PSL v2
# @Desc      :   View system information
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start executing testcase!"
    grep "NAME" /etc/os-release | grep "openEuler"
    CHECK_RESULT $?
    OS_VERSION=$(grep -w "VERSION" /etc/os-release | awk -F '"' '{print$2}')
    CHECK_RESULT $?
    grep -E "^ID" /etc/os-release | grep "openEuler"
    CHECK_RESULT $?
    if [$OS_VERSION -eq "20.09"]
    then 
        OS_VERSION_bak=${OS_VERSION}
    else
        OS_VERSION_bak=${OS_VERSION} | awk '{print$1}'
    fi
    grep -E "VERSION_ID" /etc/os-release | grep "$OS_VERSION_bak"
    CHECK_RESULT $?
    grep -E "PRETTY_NAME" /etc/os-release | grep "openEuler $OS_VERSION"
    CHECK_RESULT $?
    grep -E "ANSI_COLOR" /etc/os-release | grep "0;31"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

main $@
