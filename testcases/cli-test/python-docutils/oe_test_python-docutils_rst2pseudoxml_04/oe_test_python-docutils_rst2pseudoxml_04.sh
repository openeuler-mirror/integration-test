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
    rst2pseudoxml --pep-references testfile.rst test1.xml
    CHECK_RESULT $?
    rst2pseudoxml --pep-base-url=http://www.abc.org/dev/peps/ testfile.rst test2.xml
    CHECK_RESULT $?
    rst2pseudoxml --pep-file-url-template=pep-484 testfile.rst test3.xml
    CHECK_RESULT $?
    rst2pseudoxml --rfc-references testfile.rst test4.xml
    CHECK_RESULT $?
    rst2pseudoxml --rfc-base-url=http://www.abc.org/rfcs/ testfile.rst test5.xml
    CHECK_RESULT $?
    rst2pseudoxml --tab-width=4 testfile.rst test6.xml
    CHECK_RESULT $?
    rst2pseudoxml --trim-footnote-reference-space testfile.rst test7.xml
    CHECK_RESULT $?
    rst2pseudoxml --leave-footnote-reference-space testfile.rst test8.xml
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
