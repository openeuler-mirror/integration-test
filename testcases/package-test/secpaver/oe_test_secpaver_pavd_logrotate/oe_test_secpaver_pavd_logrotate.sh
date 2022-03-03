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
# @Date      :   2022/03/02
# @Desc      :   /var/log/secpaver/pavd.log logrotate test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    # Install pavd
    DNF_INSTALL secpaver && systemctl start pavd
}

function run_test() {
    # check log file
    for ((i = 1; i < 10; i++)); do
        grep "grpc server is listening" /var/log/secpaver/pavd.log && break
        sleep 0.1
    done
    CHECK_RESULT "$?" 0 0 "Error in log file."

    # replace log file
    mv /var/log/secpaver/pavd.log /var/log/secpaver/pavd.log.copy
    dd if=/dev/zero of=/var/log/secpaver/pavd.log bs=1M count=10
    systemctl restart pavd
    for ((i = 1; i < 100; i++)); do
        ps -ef | grep /usr/bin/pavd | grep -v grep && break
        sleep 0.01
    done
    systemctl restart pavd
    for ((i = 1; i < 100; i++)); do
        ps -ef | grep /usr/bin/pavd | grep -v grep && break
        sleep 0.01
    done
    ls /var/log/secpaver/
    CHECK_RESULT "$?" 0 0 "Error in log dir."
    ls /var/log/secpaver/ | grep "pavd-"
    CHECK_RESULT "$?" 0 0 "Error in log around."
}

function post_test() {
    systemctl stop pavd
    rm -rf /var/log/secpaver/pavd-* /var/log/secpaver/pavd.log
    mv /var/log/secpaver/pavd.log.copy /var/log/secpaver/pavd.log
    return
}

main "$@"
