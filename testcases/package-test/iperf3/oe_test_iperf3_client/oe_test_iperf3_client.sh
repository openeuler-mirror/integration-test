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
# @Desc      :   Test "iperf3 -c 127.0.0.1 -t 3 -i 1 -p 51314" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
 
function pre_test() {
    DNF_INSTALL iperf3
}

function run_test() {
    LOG_INFO "Start to run test."
    iperf3 -s -p 51314 -i 1 -D 2>&1
    SLEEP_WAIT 1
    iperf3 -c 127.0.0.1 -i 1 -t 3 -p 51314 2>&1
    CHECK_RESULT $? 0 0 "Error: iperf3 -c ... run failed"  
    LOG_INFO "End of the test."
}

function post_test() {
    kill $(pidof iperf3) 2>&1
    CHECK_RESULT $? 0 0 "Error: kill iperf3 failed"
}

main "$@"
