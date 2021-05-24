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
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-27
# @License   :   Mulan PSL v2
# @Desc      :   hostnamectl configuration hostname test
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start to run test."
    hostnamectl status
    CHECK_RESULT $?
    localhost=$(hostnamectl status | sed -n 1p | cut -d ":" -f2)
    hostnamectl set-hostname my_host
    hostnamectl status | grep "my_host"
    CHECK_RESULT $?
    hostnamectl set-hostname "Tester's notebook" --pretty
    hostnamectl status | grep "Pretty hostname" | grep "Tester's notebook"
    CHECK_RESULT $?
    hostnamectl set-hostname "" --pretty
    hostnamectl status | grep "Pretty hostname"
    CHECK_RESULT $? 1
    expect <<-EOF
    spawn hostnamectl set-hostname -H root@${NODE2_IPV4} new_host
    log_file testlog
    expect {
        "Are you sure you want to continue connecting*"
        {
            send "yes\r"
            expect "*\[P|p]assword:"
            send "${NODE2_PASSWORD}\r"
        }
        "*\[P|p]assword:"
        {
            send "${NODE2_PASSWORD}\r"
        }
    }
    expect eof
EOF
    grep -iE "fail|error" testlog
    CHECK_RESULT $? 1
    SSH_CMD "hostnamectl status" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | tail -n 10 | grep new_host
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -f testlog
    hostnamectl set-hostname ${localhost}
    expect <<-EOF
    spawn hostnamectl set-hostname -H root@${NODE2_IPV4} ${localhost}
    expect {
        "Are you sure you want to continue connecting (yes/no)?"
        {
            send "yes\r"
            expect "*\[P|p]assword:"
            send "${NODE2_PASSWORD}\r"
        }
        "*\[P|p]assword:"
        {
            send "${NODE2_PASSWORD}\r"
        }
    }
    expect eof
EOF

    LOG_INFO "End to restore the test environment."
}

main "$@"
