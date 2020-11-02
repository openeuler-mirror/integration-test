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
# @Desc      :   Working with empty linked files
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    ls test.txt && rm -rf test.txt
    ls test1.txt && rm -rf test1.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    touch test.txt
    CHECK_RESULT $?
    ls -l test.txt
    CHECK_RESULT $?
    ln -s test.txt test1.txt
    ls -l | grep "test1.txt -> test.txt"
    CHECK_RESULT $?
    rm -rf test.txt
    ls -l test.txt 2>&1 | grep "No such file or directory"
    CHECK_RESULT $?
    find ./ -type l -follow 2>/dev/null | grep test1.txt
    CHECK_RESULT $?
    rm -rf test1.txt
    ls -l | grep "test1.txt -> test.txt"
    CHECK_RESULT $? 0 1
    LOG_INFO "Finish testcase execution."
}
main "$@"
