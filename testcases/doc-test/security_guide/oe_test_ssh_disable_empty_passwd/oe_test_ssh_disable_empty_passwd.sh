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
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/5/28
# @License   :   Mulan PSL v2
# @Desc      :   It is not allowed to log in with an account with blank password
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^testuser:" /etc/passwd && userdel -rf testuser
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep "^PermitEmptyPasswords no" /etc/ssh/sshd_config
    CHECK_RESULT $?
    useradd testuser
    passwd -d testuser
    grep "^testuser" /etc/passwd
    CHECK_RESULT $?
    grep "^testuser" /etc/passwd | grep "/bin/bash"
    CHECK_RESULT $?
    passwd -S testuser 2>&1 | grep "Empty password"
    CHECK_RESULT $?
    expect <<EOF
        set timeout 15
        log_file testlog
        spawn ssh testuser@${NODE1_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect eof
EOF
    grep "password:" testlog
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    userdel -rf testuser
    rm -rf testlog
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
