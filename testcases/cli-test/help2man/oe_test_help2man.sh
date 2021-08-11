#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   ice-ktlin
#@Contact   	:   wminid@yeah.net
#@Date      	:   2021-07-14 23:33:33
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   command test help2man
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "help2man"

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    help2man --help
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man --help"

    help2man --version
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man --version"

    help2man -n 'manual page for help2man' help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -n 'manual page for help2man' help2man"

    help2man -s 1 help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -s 1 help2man"

    help2man -m 'User Commands' help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -m 'User Commands' help2man"

    help2man -L zh_CN.UTF-8 help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -L zh_CN.UTF-8 help2man"

    echo '[TEST]
The quick brown fox jumps over the lazy dog.' > ./additional.h2m

    help2man -i ./additional.h2m help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -i ./additional.h2m help2man"

    help2man -I does_not_exist.h2m help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -I does_not_exist.h2m help2man"

    help2man -p 'help2man' help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -p 'help2man' help2man"

    help2man -N help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -N help2man"

    help2man -l help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -l help2man"

    help2man -h '--help' help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -h '--help' help2man"

    help2man -v '--version' help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -v '--version' help2man"

    help2man --version-string='test' help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man --version-string='test' help2man"

    help2man --no-discard-stderr -v 'does_not_exist' help2man
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man --no-discard-stderr -v 'does_not_exist' help2man"

    help2man -o ./help2man.1 help2man
    file ./help2man.1 | grep -E '(ASCII text|UTF-8 Unicode text)' && cat ./help2man.1 | grep '\.\\" DO NOT MODIFY THIS FILE!'
    CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -o ./help2man.1 help2man"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE
    rm -rf ./additional.h2m ./help2man.1 

    LOG_INFO "End to restore the test environment."
}

main "$@"
