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
# @CaseName  :   oe_test_system_start_systemd
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Start the container through SYSTEMd
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
    isula run -tid --system-container --external-rootfs /root/myrootfs none init
    CHECK_RESULT $?

    containerName=$(isula ps -a | grep "init" | awk '{print$NF}')
    SLEEP_WAIT 10
    expect -c "
    log_file testlog
    spawn isula exec -it ${containerName} bash
    expect {
    \"*#*\" {send \"ps -ef | grep dbus\r\";
    expect \"*#*\" {send \"systemctl status dbus | grep running\r\"}
    expect \"*#*\" {send \"systemctl stop dbus\r\"}
    expect \"*#*\" {send \"systemctl status dbus | grep dead\r\"}
    expect \"*#*\" {send \"systemctl start dbus \r\"}
    expect \"*#*\" {send \"systemctl status dbus | grep running\r\"}
    expect \"*#*\" {send \"exit\r\"}
}
}
expect eof
"
    grep -iE "fail|error" testlog
    CHECK_RESULT $? 1

    grep "ps -ef" -A 5 testlog | grep -vE "ps -ef|grep" | grep "/usr/bin" | grep "dbus"
    CHECK_RESULT $?

    grep -cw "inactive" testlog | grep 1
    CHECK_RESULT $?

    grep -cw "active" testlog | grep 2
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
