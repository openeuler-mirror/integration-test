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
# @CaseName  :   oe_test_nmcli_config_dynamic_IP
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.05-08
# @License   :   Mulan PSL v2
# @Desc      :   Nmcli configure dynamic IP connection
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    test_eth=$(ls /sys/class/net/ | grep -Ewv 'lo.*|docker.*|bond.*|vlan.*|virbr.*|br.*' | grep -v $(ip route | grep ${NODE1_IPV4} | awk '{print$3}') | sed -n 1p)
    con_name='test_con'
    LOG_INFO "Loading data is complete!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    nmcli connection add type ethernet con-name ${con_name} ifname ${test_eth} | grep successfully
    CHECK_RESULT $?

    nmcli con up ${con_name}
    CHECK_RESULT $?
    nmcli device status | grep "${con_name}" | grep "connected"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    nmcli con delete ${con_name}
    LOG_INFO "Finish environment cleanup."
}

main $@
