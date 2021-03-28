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
#@Date      	:   2020-10-12
#@License   	:   Mulan PSL v2
#@Desc      	:   The command rst2pseudoxml parameter coverage test of the python-docutils package
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
    rst2pseudoxml --no-file-insertion testfile.rst test1.xml
    CHECK_RESULT $?
    rst2pseudoxml --file-insertion-enabled testfile.rst test2.xml
    CHECK_RESULT $?
    rst2pseudoxml --no-raw testfile.rst test3.xml
    CHECK_RESULT $?
    rst2pseudoxml --raw-enabled testfile.rst test4.xml
    CHECK_RESULT $?
    rst2pseudoxml --syntax-highlight=short testfile.rst test5.xml
    CHECK_RESULT $?
    rst2pseudoxml --smart-quotes=alt testfile.rst test6.xml
    CHECK_RESULT $?
    rst2pseudoxml --smartquotes-locales=xml:lang testfile.rst test7.xml
    CHECK_RESULT $?
    rst2pseudoxml --smartquotes-locales=xml:lang testfile.rst test8.xml
    CHECK_RESULT $?
    rst2pseudoxml --word-level-inline-markup testfile.rst test9.xml
    CHECK_RESULT $?
    rst2pseudoxml --character-level-inline-markup testfile.rst test10.xml
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.xml ./*.rst
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
