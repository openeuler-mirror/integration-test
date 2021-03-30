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
#@Date      	:   2020-12-15
#@License   	:   Mulan PSL v2
#@Desc      	:   command test-spent
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "opensp"
    cp -r normal.xml normal2.xml
    printf "DOCUMENT normal.xml\nDOCUMENT normal2.xml" >catalogs
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ospent -b utf-8 normal.xml | grep 'SYSTEM'
    CHECK_RESULT $?
    ospent -f error_info.log normal.xml
    test -f error_info.log
    CHECK_RESULT $?
    test "$(ospent -v normal.xml 2>&1 | grep -Eo "[0-9]\.[0-9]*\.[0-9]")" == "$(rpm -qa opensp | awk -F "-" '{print$2}')"
    CHECK_RESULT $?
    ospent -h | grep -i 'usage'
    CHECK_RESULT $?
    ospent -c SYSTEM normal.xml | grep 'SYSTEM'
    CHECK_RESULT $?
    ospent -C catalogs | grep 'SYSTEM'
    CHECK_RESULT $?
    rm -rf testdir && mkdir testdir
    cp -rf normal.xml ./testdir/
    ospent -D ./testdir/ normal.xml | grep 'SYSTEM'
    CHECK_RESULT $?
    ospent -R -D ./testdir/ normal.xml | grep 'SYSTEM'
    CHECK_RESULT $?
    ospent -n normal.xml | grep 'SYSTEM'
    CHECK_RESULT $?
    ospent -r normal.xml | grep 'SYSTEM'
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf testdir catalogs ./*.log
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

