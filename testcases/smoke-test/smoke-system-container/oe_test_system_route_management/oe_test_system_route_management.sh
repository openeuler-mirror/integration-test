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
# @CaseName  :   oe_test_system_route_management
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   route management
# ############################################

source ../common/common_lib.sh
function config_params() {
    LOG_INFO "This test case has no config params to load!"
    dest_ip="172.17.28.0"
    gw_ip="172.17.28.5"
    ip1="172.17.28.6"
    net=$(ls /sys/class/net | grep -vE "docker*|lo|virtbr*|br*|bond*|$(ip route | grep ${LOCAL_IP} | awk '{print $3}')" | sed -n 1p)
    net1=$(ls /sys/class/net | grep -vE "docker*|lo|virtbr*|br*|bond*|$(ip route | grep ${LOCAL_IP} | awk '{print $3}')" | sed -n 2p)

}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_system_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    isula run -tid --hook-spec /etc/syscontainer-tools/hookspec.json --system-container --external-rootfs /root/myrootfs none init
    CHECK_RESULT $?

    containers_id=$(isula ps -a | grep "init" | awk '{print$1}')
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containers_id} | grep running
    CHECK_RESULT $?

    syscontainer-tools add-nic --type "eth" --name ${net1}:${net} --ip ${ip1}/24 --mtu 1300 --qlen 2100 ${containers_id}
    CHECK_RESULT $?

    syscontainer-tools add-route ${containers_id} "[{\"dest\":\"${dest_ip}/32\",\"gw\":\"${gw_ip}\", \"dev\":\"${net}\"}]"
    CHECK_RESULT $?

    isula exec -it ${containers_id} ip route | grep "${dest_ip}"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_env
    LOG_INFO "Finish environment cleanup."
}

main $@
