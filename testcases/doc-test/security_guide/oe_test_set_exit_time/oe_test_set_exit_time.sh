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
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/05/27
# @License   :   Mulan PSL v2
# @Desc      :   The terminal stops running for 300 seconds and exits automatically
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    rm -rf /tmp/ssh_remote.sh
    SSH_CMD "cp /etc/profile /etc/profile.bak
            echo \\'TMOUT=300\\' >/etc/profile
            source /etc/profile" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    echo "expect<<EOF1
        set timeout 15
        spawn ssh ${NODE2_USER}@${NODE2_IPV4} 
        expect {
            \"*yes/no*\" {
                send \"yes\\r\"
            }
        }
        expect {
            \"assword:\" {
                send \"${NODE2_PASSWORD}\\r\"
            }
        }
        expect eof
        catch wait result;
        exit [lindex \\\$result 3]
EOF1" >/tmp/ssh_remote.sh
    rm -rf /root/.ssh/known_hosts
    bash -x /tmp/ssh_remote.sh &
    SLEEP_WAIT 2
    ps -axu | grep ssh | grep ${NODE2_IPV4}
    CHECK_RESULT $?
    SLEEP_WAIT 350
    ps -axu | grep ssh | grep ${NODE2_IPV4}
    CHECK_RESULT $? 0 1
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    SSH_CMD "mv /etc/profile.bak  /etc/profile
            source /etc/profile" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    rm -rf /tmp/ssh_remote.sh
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
