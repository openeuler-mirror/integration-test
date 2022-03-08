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
# @Desc      :   Check file context 2
# ##################################
source ../common/config_secpaver.sh
CURDIR=$(pwd)
set +e

function pre_test() {
    #Install pavd
    DNF_INSTALL secpaver && systemctl start pavd

    #Create resouce
    create_file_lable_test_resource

    #Import and Build project
    import_build_project testFileContext

    #Install strategy
    install_strategy testFileContext
}

function run_test() {
    cd /tmp/fileresource/ || exit 1
    ls -Z secpaverFile5 > result1
    grep "auto_secpaverfile5" result1
    CHECK_RESULT "$?" 0 0 "File lable is error."
    ls -Z secpaverFile6 > result2
    grep "\<secpaverTest6_t\>" result2
    CHECK_RESULT "$?" 0 0 "File lable is error."
    ls -Z secpaverFile7 > result3
    grep "auto_secpaverfile7" result3
    CHECK_RESULT "$?" 0 0 "File lable is error."
    ls -Z secpaverFile9 > result4
    grep "\<secpaverTest9_t\>" result4
    CHECK_RESULT "$?" 0 0 "File lable is error."
}

function post_test() {
    cd "$CURDIR" || exit 1
    uninstall_strategy testFileContext
    rm -rf /tmp/fileresource/
}

main "$@"
