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
# @Desc      :   Delete global writable property of unauthorized file
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function run_test() {
    LOG_INFO "Start executing testcase."
    testdir=$(mktemp -d)
    chmod 777 ${testdir}
    ls -al ${testdir} | awk 'NR=2' | grep "drwxrwxrwx"
    CHECK_RESULT $?
    find /tmp -type d \( -perm -o+w \) | grep -v procfind | grep ${testdir}
    CHECK_RESULT $?
    chmod o-w ${testdir}
    find /tmp -type d \( -perm -o+w \) | grep -v procfind | grep ${testdir}
    CHECK_RESULT $? 0 1
    test_txt=$(mktemp)
    chmod 777 ${test_txt}
    ls -l ${test_txt} | grep "rwxrwxrwx"
    CHECK_RESULT $?
    find /tmp -type f \( -perm -o+w \) | grep -v proc | grep ${test_txt}
    CHECK_RESULT $?
    chmod o-w ${test_txt}
    find /tmp -type f \( -perm -o+w \) | grep -v proc | grep ${test_txt}
    CHECK_RESULT $? 0 1
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    rm -rf ${test_txt} ${testdir}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
