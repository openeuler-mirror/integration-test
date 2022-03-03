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
# @Desc      :   Unix socket policy test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    #Install pavd
    DNF_INSTALL secpaver && systemctl start pavd

    #Install local ncat
    DNF_INSTALL nc

    #create temp file
    touch /home/secpaver_hostmsg

    #Import and Build project
    import_build_project testNet

    #install testNet rules
    install_strategy testNet
}

function run_test() {
    #invalid socket
    for ((i = 0; i < 5; i++)); do
        sleep 1
        rm -rf /var/run/invalid.sock
        kill -9 "$(ps -ef | grep 'ncat -lU /var/run/invalid.sock' | grep -v grep | awk '{print $2}')"
        ncat -lU /var/run/invalid.sock &
        ps -ef | grep 'ncat -lU /var/run/invalid.sock' | grep -v grep
        if [ "$?" -ne 0 ]; then
            break
        fi
    done
    ls /var/run/invalid.sock
    err=$?
    CHECK_RESULT "$err" 0 1 "fail to install ncat rules"
    if [ "$err" -eq 0 ]; then #if socket established unexpectedly, delete socket
        rm -rf /var/run/invalid.sock
        kill -9 "$(ps -ef | grep 'ncat -lU /var/run/invalid.sock' | grep -v grep | awk '{print $2}')"
    fi
    #valid socket (host)
    ncat -lU /var/run/test.sock > /home/secpaver_hostmsg &
    COUNT=0
    for ((i = 0; i < 100; i++)); do
        sleep 0.05
        COUNT=$(find /var/run/ -name test.sock | wc -l)
        [ "$COUNT" -eq 1 ] && break
    done
    CHECK_RESULT "$COUNT" 1 0 "fail to install ncat rules"
    #valid socket (client)
    echo "unix socket message" | nc -U /var/run/test.sock
    CHECK_RESULT "$?" 0 0 "bind socket error"
    cat /home/secpaver_hostmsg
    grep "unix socket message" /home/secpaver_hostmsg
    CHECK_RESULT "$?" 0 0 "fail to send message through unix socket"
}

function post_test() {
    #Uninstall strategy
    uninstall_strategy testNet

    #clear temp file
    socket_file_clear
}

main "$@"
