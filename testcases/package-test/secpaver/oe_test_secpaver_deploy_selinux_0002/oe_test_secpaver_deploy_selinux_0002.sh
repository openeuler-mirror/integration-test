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
# @Desc      :   Install/Uninstall empty policy
# ##################################
source ../common/config_secpaver.sh
set +e

function pre_test() {
    DNF_INSTALL secpaver && systemctl start pavd
}

function run_test() {
    pav project import ../common/testEmpty.zip
    pav project build -r testEmpty --engine selinux
    # install
    pav policy install testEmpty_selinux
    CHECK_RESULT "$?" 0 0 "Failed to install testEmpty policy."
    pav policy list | grep "testEmpty_selinux" | grep "active"
    CHECK_RESULT "$?" 0 0 "testEmpty_selinux policy is active"
    # uninstall
    pav policy uninstall testEmpty_selinux
    CHECK_RESULT "$?" 0 0 "Failed to uninstall project testAll."
    pav policy list | grep "testEmpty_selinux" | grep "disable"
    CHECK_RESULT "$?" 0 0 "testEmpty_selinux policy is disabled"
}

function post_test() {
    DNF_UNINSTALL secpaver 1
}

main "$@"
