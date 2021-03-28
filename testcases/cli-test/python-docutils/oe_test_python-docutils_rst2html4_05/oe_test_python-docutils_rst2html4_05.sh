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
#@Desc      	:   The command rst2html4 parameter coverage test of the python-docutils package
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
    rst2html4 --template=template_html.txt testfile.rst test1.html
    CHECK_RESULT $?
    grep '<table class="docinfo"' test1.html
    CHECK_RESULT $? 1
    cp -r /usr/lib/python3.*/site-packages/docutils/writers/html4css1/html4css1.css ./test.css
    rst2html4 --stylesheet=test.css testfile.rst test2.html
    CHECK_RESULT $?
    rst2html4 --stylesheet-path=test.css testfile.rst test3.html
    CHECK_RESULT $?
    rst2html4 --embed-stylesheet testfile.rst test4.html
    CHECK_RESULT $?
    rst2html4 --link-stylesheet testfile.rst test5.html
    CHECK_RESULT $?
    cp -rf /usr/lib/python3.*/site-packages/docutils/writers/html4css1/html4css1.css /root/
    rst2html4 --stylesheet-dirs=/root/ testfile.rst test6.html
    CHECK_RESULT $?
    rst2html4 --initial-header-level=2 testfile.rst test7.html
    CHECK_RESULT $?
    grep '<h1>' test7.html
    CHECK_RESULT $? 1
    rst2html4 --field-name-limit=7 testfile.rst test8.html
    CHECK_RESULT $?
    rst2html4 --option-limit=7 testfile.rst test9.html
    CHECK_RESULT $?
    rst2html4 --footnote-references=superscript testfile.rst test10.html
    CHECK_RESULT $?
    grep '<sup>1' test10.html
    CHECK_RESULT $?
    rst2html4 --attribution=none testfile.rst test11.html
    CHECK_RESULT $?
    grep '<p class="attribution">Buckaroo Banzai' test11.html
    CHECK_RESULT $?
    rst2html4 --compact-lists testfile.rst test12.html
    CHECK_RESULT $?
    rst2html4 --no-compact-lists testfile.rst test13.html
    CHECK_RESULT $?
    grep '<p class="first">' test13.html
    CHECK_RESULT $?
    rst2html4 --compact-field-lists testfile.rst test14.html
    CHECK_RESULT $?
    rst2html4 --compact-field-lists testfile.rst test15.html
    CHECK_RESULT $?
    rst2html4 --table-style=collapse testfile.rst test16.html
    CHECK_RESULT $?
    grep 'collapse' test16.html
    CHECK_RESULT $?
    rst2html4 --math-output=MathML testfile.rst test17.html
    CHECK_RESULT $?
    rst2html4 --no-xml-declaration testfile.rst test18.html
    CHECK_RESULT $?
    grep 'xml version="1.0"' test18.html
    CHECK_RESULT $? 1
    rst2html4 --cloak-email-addresses testfile.rst test19.html
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.html ./*.rst ./*.txt ./*.css
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
