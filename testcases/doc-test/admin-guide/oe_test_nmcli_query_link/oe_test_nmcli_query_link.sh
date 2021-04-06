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
# @CaseName  :   oe_test_nmcli_query_link
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.05-08
# @License   :   Mulan PSL v2
# @Desc      :   Nmcli connection query activation test
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    test_eth=$(ls /sys/class/net/ | grep -Ewv 'lo.*|docker.*|bond.*|vlan.*|virbr.*|br.*' | grep -v $(ip route | grep ${NODE1_IPV4} | awk '{print$3}') | sed -n 1p)
    LOG_INFO "Loading data is complete!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    nmcli con add type ethernet ifname ${test_eth} | grep successfully
    CHECK_RESULT $?

    nmcli general status | grep "connected"
    CHECK_RESULT $?
    nmcli connection show | grep "ethernet-${test_eth}"
    CHECK_RESULT $?
    nmcli connection show --active | grep "ethernet"
    CHECK_RESULT $?
    nmcli device status | grep "connected"
    CHECK_RESULT $?
    nmcli connection up id ethernet-${test_eth}
    CHECK_RESULT $?
    nmcli device disconnect ${test_eth}
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    nmcli con delete $(nmcli con show | grep ethernet- | awk -F " " '{print$1}')
    LOG_INFO "Finish environment cleanup."
}

main $@
