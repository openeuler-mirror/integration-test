#!/usr/bin/bash

#copyright (c) [2020] Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   oe_test_system_proc_isolation
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Proc file system isolation (lxcfs)
# ############################################

source ../common/common_lib.sh
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_system_env
    systemctl start lxcfs
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    isula run -tid -v /var/lib/lxc:/var/lib/lxc --hook-spec /var/lib/isulad/hooks/hookspec.json --system-container --external-rootfs /root/myrootfs none init
    CHECK_RESULT $?

    containers_id=$(isula ps -a | grep "init" | awk '{print$1}')
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containers_id} | grep running
    CHECK_RESULT $?

    isula update --cpuset-cpus 0 --memory 1G ${containers_id}
    CHECK_RESULT $?

    cpu_num1=$(isula exec ${containers_id} cat /proc/cpuinfo | grep -c processor)
    CHECK_RESULT $?
    cpu_num2=$(cat /proc/cpuinfo | grep -c processor)
    [ ${cpu_num1} != ${cpu_num2} ]
    CHECK_RESULT $?
    Mem_num1=$(isula exec ${containers_id} free -g | grep Mem | awk '{print$2}')
    CHECK_RESULT $?
    Mem_num2=$(free -g | grep Mem | awk '{print$2}')
    [ ${Mem_num1} != ${Mem_num2} ]
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_env
    LOG_INFO "Finish environment cleanup."
}

main $@
