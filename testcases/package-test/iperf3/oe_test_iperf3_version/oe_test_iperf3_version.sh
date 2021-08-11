#!/usr/bin/bash

#@ License : Mulan PSL v2
# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   juniorpy
# @Contact   :   alucard_zjh@163.com
# @Date      :   2021/07/21
# @Desc      :   Test "iperf3 --version" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    DNF_INSTALL iperf3
}

function run_test() {
    LOG_INFO "Start to run test."
    iperf3 -v 2>&1 | grep "iperf 3" 
    CHECK_RESULT $? 0 0 "Error: iperf3 -v run failed" 
    iperf3 --version  2>&1 | grep "iperf 3" 
    CHECK_RESULT $? 0 0 "Error: iperf3 --version run failed" 
    LOG_INFO "End of the test."
}

main "$@"
