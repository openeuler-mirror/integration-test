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
# @CaseName  :   test_ssh_FUN_014
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/6/4
# @License   :   Mulan PSL v2
# @Desc      :   SSH service listens only for the specified IP address
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL net-tools
    selinux_state=$(getenforce)
    if [ "$selinux_state" == "Enforcing" ]; then
        SELINUX_LLAG=1
        setenforce 0
    fi
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    getenforce 2>&1 | grep "Permissive"
    CHECK_RESULT $?
    sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 127.0.0.1/g' /etc/ssh/sshd_config
    systemctl restart sshd
    CHECK_RESULT $?
    netstat -anp | grep sshd | tr -s " " | grep "tcp 0 0 127.0.0.1:22"
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    mv /etc/ssh/sshd_config-bak /etc/ssh/sshd_config
    systemctl restart sshd
    DNF_REMOVE net-tools
    [ ${SELINUX_LLAG} -eq 1 ] && setenforce 1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
