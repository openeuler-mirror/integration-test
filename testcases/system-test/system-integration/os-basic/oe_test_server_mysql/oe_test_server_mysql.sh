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
# @CaseName  :   oe_test_server_mysql_001
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020.4.27
# @License   :   Mulan PSL v2
# @Desc      :   mysql restarts repeatedly
# ############################################

source ../common/mysql_pre.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    mysql_pre
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    for mysql_count in $(seq 1 10); do
        systemctl start mysql
        CHECK_RESULT $?

        systemctl restart mysql
        CHECK_RESULT $?

        systemctl stop mysql
        systemctl disable mysql
        CHECK_RESULT $?
        SLEEP_WAIT 2
    done

    sql_pid=$(ps -ef | grep -w mysql | grep -v grep | awk '{print$2}')
    kill -9 ${sql_pid}
    DNF_REMOVE mysql
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    sed -i 's/SELINUX=disabled/SELINUX=enforcing/g' /etc/sysconfig/selinux
    rm -rf /data/mysql
    DNF_REMOVE
    userdel -r mysql
    sed -i "/export\ PATH/d" /etc/profile
    rm -rf /tmp/mysql.sock
    LOG_INFO "Finish environment cleanup."
}

main $@
