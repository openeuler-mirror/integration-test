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
# @Desc      :   Delete unowned file
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^testuser:" /etc/passwd && userdel -rf testuser
    grep "^testgroup:" /etc/group && groupdel testgroup
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    test -z "$(find / -nouser 2>/dev/null)"
    CHECK_RESULT $?
    useradd testuser
    grep "^testuser:" /etc/passwd
    CHECK_RESULT $?
    useradd example
    grep "^example:" /etc/passwd
    CHECK_RESULT $?
    test_txt=$(mktemp)
    chown testuser ${test_txt}
    ls -l ${test_txt} | grep "testuser root"
    CHECK_RESULT $?
    userdel -rf testuser
    grep "^testuser:" /etc/passwd
    CHECK_RESULT $? 0 1
    find /tmp -nouser 2>/dev/null | grep ${test_txt}
    CHECK_RESULT $?
    rm -rf ${test_txt}
    ls -l ${test_txt} 2>&1 | grep "No such file or directory"
    CHECK_RESULT $?
    groupadd testgroup
    grep ^testgroup: /etc/group
    CHECK_RESULT $?
    test_txt=$(mktemp)
    chgrp testgroup ${test_txt}
    ls -l ${test_txt} | grep "root testgroup"
    CHECK_RESULT $?
    groupdel testgroup
    grep ^testgroup: /etc/group
    CHECK_RESULT $? 0 1
    find /tmp -nogroup 2>/dev/null | grep ${test_txt}
    CHECK_RESULT $?
    rm -rf ${test_txt}
    ls -l ${test_txt} 2>&1 | grep "No such file or directory"
    CHECK_RESULT $?

    example_txt=$(su - example -c 'mktemp')
    CHECK_RESULT $?
    su - example -c "ls -l ${example_txt} | grep 'example example'"
    CHECK_RESULT $?
    userdel -rf example
    grep "^example:" /etc/passwd
    CHECK_RESULT $? 0 1
    find /tmp -nouser 2>/dev/null | grep ${example_txt}
    CHECK_RESULT $?
    rm -rf ${example_txt}
    ls -l ${example_txt} 2>&1 | grep "No such file or directory"
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}
main "$@"
