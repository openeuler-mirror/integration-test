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
    rst2html --language=en-GB testfile.rst test1.html && grep 'lang="en-GB"' test1.html
    CHECK_RESULT $?
    rst2html --record-dependencies=recordlist.log testfile.rst test2.html && grep 'html4css1.css' recordlist.log
    CHECK_RESULT $?
    test "$(rst2html -V | grep -Eo 'Docutils [0-9]*\.[0-9]* '| grep -Eo '[0-9]*\.[0-9]*')" == "$(rpm -qa python3-docutils | awk -F "-" '{print$3}')"
    CHECK_RESULT $?
    rst2html -h | grep 'Usage'
    CHECK_RESULT $?
    rst2html --no-doc-title testfile.rst test5.html
    CHECK_RESULT $?
    rst2html --no-doc-info testfile.rst test6.html
    CHECK_RESULT $?
    rst2html --section-subtitles testfile.rst test7.html
    CHECK_RESULT $?
    rst2html --no-section-subtitles testfile.rst test8.html
    CHECK_RESULT $?
    rst2html --pep-references testfile.rst test9.html
    CHECK_RESULT $?
    rst2html --pep-base-url=http://www.abc.org/dev/peps/ testfile.rst test10.html
    CHECK_RESULT $?
    rst2html --pep-file-url-template=pep-484 testfile.rst test11.html
    CHECK_RESULT $?
    rst2html --rfc-references testfile.rst test12.html
    CHECK_RESULT $?
    rst2html --rfc-base-url=http://www.abc.org/rfcs/ testfile.rst test13.html
    CHECK_RESULT $?
    rst2html --tab-width=4 testfile.rst test14.html
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
