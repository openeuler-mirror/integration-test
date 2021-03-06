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
#@Author    	:   doraemon2020
#@Contact   	:   xcl_job@163.com
#@Date      	:   2020-10-13
#@License   	:   Mulan PSL v2
#@Desc      	:   The command rst2html5 parameter coverage test of the python-docutils package
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp -r ../common/error.rst ./
    DNF_INSTALL "python-docutils"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rst2html5 -r 1 error.rst test17.html
    CHECK_RESULT $?
    rst2html5 -v error.rst test18.html
    CHECK_RESULT $?
    rst2html5 -q error.rst test19.html
    CHECK_RESULT $?
    rst2html5 --halt=1 error.rst test20.html 2>&1 | grep 'due to level-1'
    CHECK_RESULT $?
    ls test20.html
    CHECK_RESULT $? 0 1
    rst2html5 --strict error.rst test21.html 2>&1 | grep 'Exiting due to level-1'
    CHECK_RESULT $?
    test -f test21.html
    CHECK_RESULT $? 0 1
    rst2html5 --exit-status=1 error.rst test22.html 2>&1 | grep 'INFO'
    CHECK_RESULT $? 1
    test -f test22.html
    CHECK_RESULT $?
    rst2html5 --debug error.rst test23.html 2>&1 | grep 'DEBUG'
    CHECK_RESULT $?
    rst2html5 --no-debug error.rst test23.html
    CHECK_RESULT $?
    rst2html5 --halt=1 --warnings=warning.log error.rst test24.html 2>&1 | grep 'due to level-1' && ls warning.log
    CHECK_RESULT $?
    rst2html5 --traceback error.rst test25.html
    CHECK_RESULT $?
    rst2html5 --no-traceback error.rst test25.html
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.html ./*.rst ./*.log
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
