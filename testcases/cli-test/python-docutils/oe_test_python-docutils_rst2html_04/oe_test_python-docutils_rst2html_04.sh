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
#@Desc      	:   The command rst2html parameter coverage test of the python-docutils package
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
    rst2html --trim-footnote-reference-space testfile.rst test1.html
    CHECK_RESULT $?
    rst2html --leave-footnote-reference-space testfile.rst test2.html
    CHECK_RESULT $?
    rst2html --no-file-insertion testfile.rst test3.html
    CHECK_RESULT $?
    rst2html --file-insertion-enabled testfile.rst test4.html
    CHECK_RESULT $?
    rst2html --no-raw testfile.rst test5.html
    CHECK_RESULT $?
    rst2html --raw-enabled testfile.rst test6.html
    CHECK_RESULT $?
    rst2html --syntax-highlight=short testfile.rst test7.html
    CHECK_RESULT $?
    rst2html --smart-quotes=alt testfile.rst test8.html
    CHECK_RESULT $?
    rst2html --smartquotes-locales=xml:lang testfile.rst test9.html
    CHECK_RESULT $?
    rst2html --word-level-inline-markup testfile.rst test10.html
    CHECK_RESULT $?
    rst2html --character-level-inline-markup testfile.rst test11.html
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.html ./*.rst
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
