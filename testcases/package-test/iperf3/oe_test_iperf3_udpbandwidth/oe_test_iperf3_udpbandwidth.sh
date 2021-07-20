#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test "iperf3 -u -c 127.0.0.1 -b 10M -P 10 -t 3" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    iperf3 -s -p 51314 -D 2>&1
    sleep 1
    iperf3 -u -c 127.0.0.1 -p 51314 -b 10M -P 10 -t 3 2>&1
    CHECK_RESULT $? 0 0   
    kill $(pidof iperf3)
    CHECK_RESULT $? 0 0   
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Need't to restore the tet environment."
}

main "$@"
