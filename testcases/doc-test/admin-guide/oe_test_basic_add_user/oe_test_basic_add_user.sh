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
# @CaseName  :   oe_test_basic_add_user
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.04-09
# @License   :   Mulan PSL v2
# @Desc      :   Add User test
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start executing testcase!"
    user="testuser"
    egrep -E "^${user}|^${user}1" /etc/passwd >& /dev/null  
    if [ $? -ne 0 ]
    then  
        useradd ${user}  
        useradd -e 2020-10-30 ${user}1
    fi  
    passwd testuser <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    CHECK_RESULT $?
    grep -E "^${user}|^${user}1" /etc/passwd
    CHECK_RESULT $?

    chage -l ${user}1 | grep 2020 | grep 30
    CHECK_RESULT $?

    chage -M 4 ${user}1
    chage -l ${user}1 | grep Maximum | grep 4
    
    useradd --help
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -r ${user}
    userdel -r ${user}1
    LOG_INFO "Finish environment cleanup."
}

main $@
