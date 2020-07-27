#!/usr/bin/bash

# Copyright (c) 2020 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yuanlulu
# @Contact   :   cynthiayuanll@163.com
# @Date      :   2020-07-27
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-acl
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    ls /tmp/acl01 && rm -rf /tmp/acl01
    pre=$(cat /etc/passwd |grep -w "testuser"|awk -F : '{print $1}')
    [ -n "$pre" ] || useradd testuser
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    mkdir -p /tmp/acl01/acl02
    pre01=$(getfacl -p /tmp/acl01|grep "user"|awk -F : '{print $2}'|grep -w "testuser")
    [ -z "$pre01" ]
    CHECK_RESULT $?

    setfacl -m u:testuser:rx /tmp/acl01
    pre02=$(getfacl -p /tmp/acl01|grep "user"|awk -F : '{print $2}'|grep -w "testuser")
    touch /tmp/acl01/acl02
    pre03=$(getfacl -p /tmp/acl01/acl02|grep "user"|awk -F : '{print $2}'|grep -w "testuser")
    [ -n "$pre02" ]
    CHECK_RESULT $?
    [ -z "$pre03" ] 
    CHECK_RESULT $?

    setfacl -m d:u:testuser:rx /tmp/acl01
    pre04=$(getfacl -p /tmp/acl01|grep "user"|awk -F : '{print $2}'|grep -w "testuser")
    touch /tmp/acl01/acl03
    pre05=$(getfacl -p /tmp/acl01/acl03|grep "user"|awk -F : '{print $2}'|grep -w "testuser")
    [ -n "$pre04" ]
    CHECK_RESULT $?
    [ -n "$pre05" ] 
    CHECK_RESULT $?

    setfacl -b /tmp/acl01
    pre06=$(getfacl -p /tmp/acl01|grep "user"|awk -F : '{print $2}'|grep -w "testuser")
    pre07=$(getfacl -p /tmp/acl01/acl02|grep "user"|awk -F : '{print $2}'|grep -w "testuser")
    pre08=$(getfacl -p /tmp/acl01/acl08|grep "user"|awk -F : '{print $2}'|grep -w "testuser")
    [ -z "$pre06" ] 
    CHECK_RESULT $?
    [ -z "$pre07" ]
    CHECK_RESULT $?
    [ -z "$pre08" ] 
    CHECK_RESULT $?

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/acl01 && userdel testuser
    LOG_INFO "Finish environment cleanup!"
}

main $@
