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
# @Desc      :   Verify restrict access to cron
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^testuser1:" /etc/passwd && userdel -rf testuser1
    grep "^testuser2:" /etc/passwd && userdel -rf testuser2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    ls -l /etc/cron.deny 2>&1 | grep "No such file or directory"
    CHECK_RESULT $?
    ls -l /etc/cron.allow | grep "root root" | grep '\-rw\-\-\-\-\-\-\-\.'
    CHECK_RESULT $?
    useradd testuser1
    grep "^testuser1:" /etc/passwd
    CHECK_RESULT $?
    useradd testuser2
    grep "^testuser2:" /etc/passwd
    CHECK_RESULT $?
    echo testuser1 >>/etc/cron.allow
    grep "^testuser1" /etc/cron.allow
    CHECK_RESULT $?
    su - testuser1 -c "id 2>&1" | grep "testuser1"
    CHECK_RESULT $?
    su - testuser1 -c "crontab -l 2>&1" | grep "no crontab for testuser1"
    CHECK_RESULT $?
    su - testuser2 -c "id 2>&1" | grep "testuser2"
    CHECK_RESULT $?
    su - testuser2 -c "crontab -l 2>&1" | grep "You (testuser2) are not allowed to use this program (crontab)"
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    mv /etc/cron.allow-bak /etc/cron.allow -f
    test -f /etc/cron.deny-bak && mv /etc/cron.deny-bak /etc/cron.deny -f
    userdel -rf testuser1
    userdel -rf testuser2
    rm -rf /run/faillock/testuser1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
