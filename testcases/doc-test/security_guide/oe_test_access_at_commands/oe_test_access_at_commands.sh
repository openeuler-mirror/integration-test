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
# @Date      :   2020/5/27
# @License   :   Mulan PSL v2
# @Desc      :   Verify restrict access to at commands
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL at
    cp /etc/at.allow /etc/at.allow-bak
    cp /etc/at.deny /etc/at.deny-bak
    grep "^testuser1:" /etc/passwd && userdel -rf testuser1
    grep "^testuser2:" /etc/passwd && userdel -rf testuser2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    rm -rf /etc/at.deny
    ls -l /etc/at.deny 2>&1 | grep "No such file or directory"
    CHECK_RESULT $?
    chown root:root /etc/at.allow
    chmod og-rwx /etc/at.allow
    ls -l /etc/at.allow | grep "root root" | grep '\-rw\-\-\-\-\-\-\-\.'
    CHECK_RESULT $?
    useradd testuser1
    grep "^testuser1:" /etc/passwd
    CHECK_RESULT $?
    useradd testuser2
    grep "^testuser2:" /etc/passwd
    CHECK_RESULT $?
    echo testuser1 >>/etc/at.allow
    grep "^testuser1" /etc/at.allow
    su - testuser1 -c "id 2>&1" | grep "testuser1"
    CHECK_RESULT $?
    su - testuser1 -c "at 2>&1" | grep "Garbled time"
    CHECK_RESULT $?
    su - testuser2 -c "id 2>&1" | grep "testuser2"
    CHECK_RESULT $?
    su - testuser2 -c "at 2>&1" | grep "You do not have permission to use at"
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    mv /etc/at.allow-bak /etc/at.allow -f
    mv /etc/at.deny-bak /etc/at.deny -f
    DNF_REMOVE at
    userdel -rf testuser1
    userdel -rf testuser2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
