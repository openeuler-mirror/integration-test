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
# @Date      :   2022/03/01
# @Desc      :   pav engine list cmd test
# ##################################
source ../common/config_secpaver.sh
set +e

function pre_test() {
    DNF_INSTALL secpaver && systemctl start pavd
}

function run_test() {
    pav engine list
    CHECK_RESULT $? 0 0 "pav engine list cmd failed"
    pav engine list | grep selinux
    CHECK_RESULT $? 0 0 "support selinux policy"
    pav engine list | grep apparmor
    CHECK_RESULT $? 0 1 "not support apparmor policy"
}

function post_test() {
    DNF_UNINSTALL secpaver 1
}

main "$@"
