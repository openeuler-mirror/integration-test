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
#@Date      	:   2020-10-16
#@License   	:   Mulan PSL v2
#@Desc      	:   The command rst2latex parameter coverage test of the python-docutils package
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp -r ../common/testfile_tex.rst ./testfile.rst
    touch subfig.sty
    DNF_INSTALL "python-docutils"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rst2latex --language=fr testfile.rst test1.tex && grep 'french' test1.tex
    CHECK_RESULT $?
    rst2latex --record-dependencies=recordlist.log testfile.rst test2.tex
    CHECK_RESULT $?
    test "$(rst2latex -V | grep -Eo 'Docutils [0-9]*\.[0-9]* '| grep -Eo '[0-9]*\.[0-9]*')" == "$(rpm -qa python3-docutils | awk -F "-" '{print$3}')"
    CHECK_RESULT $?
    rst2latex -h | grep 'Usage'
    CHECK_RESULT $?
    rst2latex --no-doc-title testfile.rst test5.tex
    CHECK_RESULT $?
    rst2latex --no-doc-info testfile.rst test6.tex
    CHECK_RESULT $?
    rst2latex --section-subtitles testfile.rst test7.tex
    CHECK_RESULT $?
    rst2latex --no-section-subtitles testfile.rst test8.tex
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.tex ./*.rst ./*.log ./*.sty
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
