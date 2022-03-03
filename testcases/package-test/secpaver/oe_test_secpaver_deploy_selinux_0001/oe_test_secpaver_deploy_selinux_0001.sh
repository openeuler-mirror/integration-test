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
# @Desc      :   Install/Uninstall secpaver policy
# ##################################
source ../common/config_secpaver.sh
set +e

function pre_test() {
    DNF_INSTALL secpaver && systemctl start pavd
}

function run_test() {
    pav project import ../common/testAll.zip
    pav project build -r testAll --engine selinux
    # install
    pav policy install testAll_public_selinux
    CHECK_RESULT "$?" 0 0 "Failed to install main policy."
    pav policy list | grep "testAll" | grep -v "testAll_public" | awk '{print $1}' | xargs -L 1 pav policy install
    CHECK_RESULT "$?" 0 0 "Failed to install sub policy."
    # uninstall
    pav policy uninstall testAll_public_selinux
    CHECK_RESULT "$?" 0 1 "Failed to uninstall main policy."
    pav policy list | grep "testAll" | grep -v "testAll_public" | awk '{print $1}' | xargs -L 1 pav policy uninstall
    CHECK_RESULT "$?" 0 0 "Failed to uninstall sub policy."
    # uninstall main policy
    pav policy uninstall testAll_public_selinux
    CHECK_RESULT "$?" 0 0 "Failed to uninstall main policy."
}

function post_test() {
    cd "$WDIR" || exit 1
    DNF_UNINSTALL secpaver 1
}

main "$@"
