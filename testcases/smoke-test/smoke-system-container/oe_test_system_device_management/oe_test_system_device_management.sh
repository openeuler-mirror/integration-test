#!/usr/bin/bash

#copyright (c) 2020 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   oe_test_system_device_management
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   device management
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
    disk=$(lsblk | awk 'END {print}' | awk '{print$1}')
    isula run -tid --hook-spec /etc/syscontainer-tools/hookspec.json --system-container --external-rootfs /root/myrootfs --cap-add sys_admin none init
    CHECK_RESULT $?

    containers_id=$(isula ps -a | grep "init" | awk '{print$1}')
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containers_id} | grep running
    CHECK_RESULT $?

    syscontainer-tools add-device ${containers_id} /dev/${disk}
    CHECK_RESULT $?
    syscontainer-tools remove-device ${containers_id} /dev/${disk} | grep done
    CHECK_RESULT $?

    isula exec ${containers_id} fdisk -l /dev/${disk}
    CHECK_RESULT $? 1

    syscontainer-tools add-device ${containers_id} /dev/${disk}
    CHECK_RESULT $?

    syscontainer-tools update-device --device-read-bps /dev/${disk}:10m ${containers_id}
    CHECK_RESULT $?

    isula exec ${containers_id} fdisk -l | grep ${disk}
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_env
    LOG_INFO "Finish environment cleanup."
}

main $@
