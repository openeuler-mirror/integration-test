#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2020-10-19
#@License   	:   Mulan PSL v2
#@Desc      	:   The command rst2man parameter coverage test of the python-docutils package
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp -r ../common/testfile.rst ./
    DNF_INSTALL "python-docutils"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rst2man --no-raw testfile.rst test1.man
    CHECK_RESULT $?
    rst2man --raw-enabled testfile.rst test2.man
    CHECK_RESULT $?
    rst2man --syntax-highlight=short testfile.rst test3.man
    CHECK_RESULT $?
    rst2man --smart-quotes=alt testfile.rst test4.man
    CHECK_RESULT $?
    rst2man --smartquotes-locales=xml:lang testfile.rst test5.man
    CHECK_RESULT $?
    rst2man --smartquotes-locales=xml:lang testfile.rst test6.man
    CHECK_RESULT $?
    rst2man --word-level-inline-markup testfile.rst test7.man
    CHECK_RESULT $?
    rst2man --character-level-inline-markup testfile.rst test8.man
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.man ./*.rst ./*.log
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
