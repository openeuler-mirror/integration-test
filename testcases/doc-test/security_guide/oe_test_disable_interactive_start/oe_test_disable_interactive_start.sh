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
# @Date      :   2020/05/27
# @License   :   Mulan PSL v2
# @Desc      :   Prohibit interactive startup service
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^test:" /etc/passwd && userdel -rf test
    grep '#%wheel' /etc/sudoers && sed -i 's/#%wheel/%wheel/g' /etc/sudoers
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep "PROMPT=no" /etc/sysconfig/init
    CHECK_RESULT $?
    useradd test
    passwd test <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    useradd example
    passwd example <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    su - test -c "systemctl stop firewalld 2>&1" | grep 'Interactive authentication required'
    CHECK_RESULT $?
    usermod -g wheel example
    su - example <<EOF
    expect <<EOF
        log_file /home/example/result
        set timeout 15
        spawn sudo systemctl stop firewalld
        expect {
            "password" {
                send "${NODE1_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    grep 'Interactive authentication required' /home/example/result
    CHECK_RESULT $? 0 1
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    usermod -g example example
    userdel -rf example
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
