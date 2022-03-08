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
# @Date      :   2022/03/02
# @Desc      :   pav project build cmd test
# ##################################
source ../common/config_secpaver.sh
set +e

function pre_test() {
    DNF_INSTALL secpaver && systemctl start pavd
    project_import
}

function run_test() {
    pav project build -r "$project_name" --engine selinux
    CHECK_RESULT $? 0 0  "pav project build failed"
    pav project build -r proj --engine selinux > result1 2>&1
    CHECK_RESULT $? 0 1 "pav project build should failed"
    grep 'proj directory not found' result1
    CHECK_RESULT $? 0 0 "print error"
    pav project build -r "$project_name" --engine sea > result2 2>&1
    CHECK_RESULT $? 0 1  "pav project build --engine sea should failed"
    grep 'invalid engine' result2
    CHECK_RESULT $? 0 0 "print error"
    pav project build -d /testpav --engine selinux > result3 2>&1
    CHECK_RESULT $? 0 1 "pav project build should failed"
    grep 'testpav directory not found' result3
    CHECK_RESULT $? 0 0 "print error"
}

function post_test() {
    pav project delete "$project_name"
    rm -rf p*
    DNF_UNINSTALL secpaver 1
}

main "$@"
