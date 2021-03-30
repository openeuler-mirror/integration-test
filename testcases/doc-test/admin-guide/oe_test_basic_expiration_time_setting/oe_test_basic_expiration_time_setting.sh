#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   oe_test_basic_expiration_time_setting
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.04-09
# @License   :   Mulan PSL v2
# @Desc      :   Set account and password expiration time test
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    user_group="testuser"
    egrep "^${user_group}" /etc/passwd >& /dev/null  
    if [ $? -ne 0 ]  
    then  
        useradd ${user_group}  
    fi 

    egrep "^${user_group}" /etc/group >& /dev/null  
    if [ $? -eq 0 ]  
    then  
        groupdel ${user_group}
    fi 
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    grep ${user_group} /etc/passwd
    CHECK_RESULT $?
    chage -l ${user_group}
    chage -E 2020-03-01 ${user_group}
    chage -l ${user_group} | grep 2020 | grep Mar | grep 01
    CHECK_RESULT $?
    chage -M 4 ${user_group}
    chage -l ${user_group} | grep Maximum | grep 4
    useradd --help
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -r ${user_group}
    LOG_INFO "Finish environment cleanup."
}

main $@
