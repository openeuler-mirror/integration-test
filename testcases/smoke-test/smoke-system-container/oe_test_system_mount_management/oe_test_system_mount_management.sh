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
# @CaseName  :   oe_test_system_mount_management
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   mount management
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
    isula run -tid --hook-spec /etc/syscontainer-tools/hookspec.json --system-container --external-rootfs /root/myrootfs none init
    CHECK_RESULT $?

    containers_id=$(isula ps -a | grep "init" | awk '{print$1}')
    CHECK_RESULT $?
    isula inspect -f {{.State.Status}} ${containers_id} | grep running
    CHECK_RESULT $?

    syscontainer-tools add-path ${containers_id} /home/test123:/home/test123
    CHECK_RESULT $?

    LOG_INFO "systemtest" >/home/test123/helloworld
    CHECK_RESULT $?

    expect -c "
    log_file testlog
    spawn isula exec -it ${containers_id} bash
    expect {
    \"*/*\" {send \"cat /home/test123/helloworld\r\";
    expect \"*/*\" {send \"exit\r\"}
}
}
expect eof
"
    grep -i 'systemtest' testlog
    CHECK_RESULT $?

    syscontainer-tools remove-path ${containers_id} /home/test123:/home/test123
    CHECK_RESULT $?

    expect -c "
    log_file testlog
    spawn isula exec -it  ${containers_id} bash
    expect {
    \"*#*\" {send \"find /home/test123/helloworld\r\";
    expect \"*#*\" {send \"exit\r\"}
}
}
expect eof
"
    grep -i 'No such file or directory' testlog
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_env
    rm -rf testlog
    LOG_INFO "Finish environment cleanup."
}

main $@
