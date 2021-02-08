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
#@Date      	:   2020-10-13
#@License   	:   Mulan PSL v2
#@Desc      	:   The command rst2s5 parameter coverage test of the python-docutils package
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp -r ../common/testfile.rst ./
    cp -r ../common/template_html.txt ./
    DNF_INSTALL "python-docutils"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rst2s5 --template=template_html.txt testfile.rst test1.html
    CHECK_RESULT $?
    grep '<table class="docinfo"' test1.html
    CHECK_RESULT $? 0 1
    cp -r /usr/lib/python3.*/site-packages/docutils/writers/html4css1/html4css1.css ./test.css
    rst2s5 --stylesheet=test.css testfile.rst test2.html
    CHECK_RESULT $?
    rst2s5 --stylesheet-path=test.css testfile.rst test3.html
    CHECK_RESULT $?
    rst2s5 --embed-stylesheet testfile.rst test4.html
    CHECK_RESULT $?
    rst2s5 --link-stylesheet testfile.rst test5.html
    CHECK_RESULT $?
    cp -rf /usr/lib/python3.*/site-packages/docutils/writers/html4css1/html4css1.css /root/
    rst2s5 --stylesheet-dirs=/root/ testfile.rst test6.html
    CHECK_RESULT $?
    rst2s5 --initial-header-level=2 testfile.rst test7.html
    CHECK_RESULT $?
    grep '<h1>' test7.html
    CHECK_RESULT $? 0 1
    rst2s5 --field-name-limit=7 testfile.rst test8.html
    CHECK_RESULT $?
    rst2s5 --option-limit=7 testfile.rst test9.html
    CHECK_RESULT $?
    rst2s5 --footnote-references=superscript testfile.rst test10.html && grep '<sup>1' test10.html
    CHECK_RESULT $?
    rst2s5 --attribution=none testfile.rst test11.html && grep '<p class="attribution">Buckaroo Banzai' test11.html
    CHECK_RESULT $?
    rst2s5 --compact-lists testfile.rst test12.html
    CHECK_RESULT $?
    rst2s5 --no-compact-lists testfile.rst test13.html && grep '<p class="first">' test13.html
    CHECK_RESULT $?
    rst2s5 --compact-field-lists testfile.rst test14.html
    CHECK_RESULT $?
    rst2s5 --compact-field-lists testfile.rst test15.html
    CHECK_RESULT $?
    rst2s5 --table-style=collapse testfile.rst test16.html && grep 'collapse' test16.html
    CHECK_RESULT $?
    rst2s5 --math-output=MathML testfile.rst test17.html
    CHECK_RESULT $?
    rst2s5 --no-xml-declaration testfile.rst test18.html
    CHECK_RESULT $?
    grep 'xml version="1.0"' test18.html
    CHECK_RESULT $? 0 1
    rst2s5 --cloak-email-addresses testfile.rst test19.html
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.html ./*.rst ./*.log ./ui ./*.txt ./*.css
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
