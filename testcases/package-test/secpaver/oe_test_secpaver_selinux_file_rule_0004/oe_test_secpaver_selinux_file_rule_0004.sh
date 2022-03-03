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
# @Date      :   2022/03/03
# @Desc      :   selinux rules test: create file
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    #Install pavd
    DNF_INSTALL secpaver && systemctl start pavd

    #Create resouce
    resource_create filesystem_test

    #Import and Build project
    import_build_project testAll

    #Install strategy
    install_strategy testAll
}

function run_test() {
    filesystem_test true
    CHECK_RESULT "$?" 0 0 "Failed to install create rules."
    filesystem_test false
    CHECK_RESULT "$?" 0 1 "Failed to install create rules."
    ls -l /resource >> index
    count_true=$(grep -c all index)
    CHECK_RESULT "${count_true}" 1 0 "Failed to create file."
    count_false=$(grep -c false index)
    CHECK_RESULT "${count_false}" 0 0 "Failed to create file."
    rm -rf index
}

function post_test() {
    #Uninstall strategy
    uninstall_strategy testAll

    #Clear resource
    resource_clear filesystem_test
}

main "$@"
