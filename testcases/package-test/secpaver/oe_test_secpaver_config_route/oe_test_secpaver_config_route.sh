#!/usr/bin/bash

#@ License : Mulan PSL v2
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   zengxianjun
# @Contact   :   mistachio@163.com
# @Date      :   2022/02/28
# @Desc      :   Secpaver config file function test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    # Install pavd
    DNF_INSTALL secpaver && systemctl start pavd

    # clear directory of compiled file
    rm -rf /var/local/secpaver/policies/*

    # Import empty project and compile
    pav project import ../common/testEmpty.zip
    pav project build -r testEmpty --engine selinux
}

function run_test() {
    # check compiled file
    ls /var/local/secpaver/policies/selinux
    CHECK_RESULT "$?" 0 0 "Cannot find compiled files."

    # check log file
    ls /var/log/secpaver/pavd.log
    CHECK_RESULT "$?" 0 0 "Cannot find log file."
}

function post_test() {
    # delete temp file
    rm -rf output

    # delete policy file
    rm -rf policy_testEmpty_selinux.zip
}

main "$@"
