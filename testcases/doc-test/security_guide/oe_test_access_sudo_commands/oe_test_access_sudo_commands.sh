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
# @Desc      :   Verify restrictions on sudo commands
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^testuser:" /etc/passwd && userdel -rf testuser
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    sed -i '/wheel/s/^/#&/g' /etc/sudoers
    grep "^#%wheel" /etc/sudoers
    CHECK_RESULT $?
    useradd testuser
    grep "^testuser" /etc/passwd
    CHECK_RESULT $?
    useradd example
    grep "^example" /etc/passwd
    CHECK_RESULT $?
    passwd testuser <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    usermod -g wheel testuser
    groups testuser | grep "testuser : wheel"
    CHECK_RESULT $?
    usermod -g wheel example
    groups example | grep "example : wheel"
    CHECK_RESULT $?
    su - testuser <<EOF
    id 2>&1 >/home/testuser/id.log
    expect <<EOF
        log_file /home/testuser/testlog
        set timeout 15
        spawn sudo ls /etc
        expect {
            "password" {
                send "${NODE1_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    grep "testuser" /home/testuser/id.log
    CHECK_RESULT $?
    grep "testuser is not in the sudoers file.  This incident will be reported." /home/testuser/testlog
    CHECK_RESULT $?
    su - example <<EOF
    id 2>&1 >/home/example/id.log
    expect <<EOF
        log_file /home/example/testlog
        set timeout 15
        spawn sudo ls /etc
        expect {
            "password" {
                send "${NODE1_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    grep "example" /home/example/id.log
    CHECK_RESULT $?
    grep "Sorry, try again" /home/example/testlog
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    sed -i 's/#%wheel/%wheel/g' /etc/sudoers
    usermod -g testuser testuser
    userdel -rf testuser
    usermod -g example example
    userdel -rf example
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
