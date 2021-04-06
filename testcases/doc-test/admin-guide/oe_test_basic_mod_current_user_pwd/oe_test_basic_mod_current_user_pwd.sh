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
# @CaseName  :   oe_test_basic_mod_current_user_pwd
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.04-09
# @License   :   Mulan PSL v2
# @Desc      :   User password modification_current user
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start executing testcase!"
    useradd test26
    passwd test26 <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    echo test >/home/test
    su test26 -c "mkdir -p /home/test26"
    CHECK_RESULT $?
    expect -c"
        spawn scp /home/test test26@${NODE1_IPV4}:/home/test26
        expect {
                \"*)?\"  {
                        send \"yes\r\"
                        exp_continue
                }
                \"*assword:*\"  {
                        send \"${NODE1_PASSWORD}\r\"
                        exp_continue
                }
}
"
    su test26 -c "ls /home/test26/test"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -r test26
    rm -rf /home/test
    LOG_INFO "Finish environment cleanup."
}

main $@
