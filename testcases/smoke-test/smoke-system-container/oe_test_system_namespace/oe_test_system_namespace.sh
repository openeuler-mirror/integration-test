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
# @CaseName  :   oe_test_system_namespace
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   User namespace many to many
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
    chmod 777 /root
    CHECK_RESULT $?
    chown 100000:100000 /root/myrootfs
    CHECK_RESULT $?
    isula run -tid --user-remap 100000:100000:65535 --system-container --external-rootfs /root/myrootfs --cap-add sys_admin none /sbin/init
    CHECK_RESULT $?

    containers_id=$(isula ps -a | grep "init" | awk '{print$1}')
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containers_id} | grep running
    CHECK_RESULT $?

    isula exec ${containers_id} ps aux | grep /sbin/init
    CHECK_RESULT $?
    ps aux | grep /sbin/init
    CHECK_RESULT $?

    expect -c "
    log_file testlog
    spawn isula exec -it  ${containers_id} bash
    expect {
    \"*#*\" {send \"echo systemtest > /test123\r\";
    expect \"*/*\" {send \"exit\r\"}
}
}
expect eof
"
    grep systemtest /root/myrootfs/test123
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_env
    rm -rf testlog
    chmod 550 /root
    LOG_INFO "Finish environment cleanup."
}

main $@
