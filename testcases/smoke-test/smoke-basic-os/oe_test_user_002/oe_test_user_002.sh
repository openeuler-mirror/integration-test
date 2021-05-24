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
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   test -g -s -m and delete user
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function config_params() { 
    LOG_INFO "Start config params preparation."
    cur_date=$(date +%Y%m%d%H%M%S)
    group="testGroup"$cur_date
    user="testUser"$cur_date
    LOG_INFO "End of config params preparation!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    cat /etc/passwd | grep "$user:" && userdel -rf $user
    cat /etc/group | grep "$group:" && groupdel test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    groupadd $group
    gid=$(cat /etc/group | grep $group | awk -F':' '{print $3}')
    useradd -g $gid -s /sbin/nologin -m $user
    CHECK_RESULT $?
    su $user | grep 'account is currently not available'
    CHECK_RESULT $?
    test $(cat /etc/passwd | grep $user | awk -F ':' '{print $4}') -eq $gid
    CHECK_RESULT $?
    ls /home | grep $user
    CHECK_RESULT $?
    userdel -rf $user
    CHECK_RESULT $?
    ls /home | grep $user
    CHECK_RESULT $? 1
    cat /etc/passwd | grep $user
    CHECK_RESULT $? 1
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    groupdel $group
    LOG_INFO "Finish environment cleanup!"
}

main $@
