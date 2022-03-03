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
# @Desc      :   Secpaver cmd authority test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    # Install pavd
    DNF_INSTALL secpaver && systemctl start pavd

    # Add user
    useradd generalUser1
}

function run_test() {
    # pav command
    su - generalUser1 -c "pav project list"
    CHECK_RESULT "$?" 0 1 "invalid permission for general user to execute pav commands"
    # systemctl start pavd
    su - generalUser1 -c "systemctl start pavd"
    CHECK_RESULT "$?" 0 1 "invalid permission for general user to start pavd"
    # systemctl start pavd
    su - generalUser1 -c "pavd --help"
    CHECK_RESULT "$?" 0 1 "invalid permission for general user to execute pavd commands"
}

function post_test() {
    # delete temp file
    rm -rf output

    # delete user
    userdel -r generalUser1
}

main "$@"
