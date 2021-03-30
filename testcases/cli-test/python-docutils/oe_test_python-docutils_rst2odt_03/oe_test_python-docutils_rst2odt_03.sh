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
#@Date      	:   2020-10-19
#@License   	:   Mulan PSL v2
#@Desc      	:   The command rst2odt parameter coverage test of the python-docutils package
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp -r ../common/testfile_odt.rst ./testfile.rst
    DNF_INSTALL "python-docutils"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rst2odt --language=en-GB testfile.rst test1.odt
    CHECK_RESULT $?
    rst2odt --record-dependencies=recordlist.log testfile.rst test2.odt
    CHECK_RESULT $?
    test "$(rst2odt -V | grep -Eo 'Docutils [0-9]*\.[0-9]* '| grep -Eo '[0-9]*\.[0-9]*')" == "$(rpm -qa python3-docutils | awk -F "-" '{print$3}')"
    CHECK_RESULT $?
    rst2odt -h | grep 'Usage'
    CHECK_RESULT $?
    rst2odt --no-doc-title testfile.rst test5.odt
    CHECK_RESULT $?
    rst2odt --no-doc-info testfile.rst test6.odt
    CHECK_RESULT $?
    rst2odt --section-subtitles testfile.rst test7.odt
    CHECK_RESULT $?
    rst2odt --no-section-subtitles testfile.rst test8.odt
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.odt ./*.rst ./*.log
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
