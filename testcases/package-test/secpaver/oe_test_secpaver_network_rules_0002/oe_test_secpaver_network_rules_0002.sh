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
# @Desc      :   Tcp socket policy test
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
    #invalid port
    for ((i = 0; i < 5; i++)); do
        sleep 1
        kill -9 "$(ps -ef | grep 'ncat -lv 5009' | grep -v grep | awk '{print $2}')"
        ncat -lv 5009 &
        ps -ef | grep 'ncat -lv 5009' | grep -v grep
        if [ "$?" -ne 0 ]; then
            break
        fi
    done
    ps -ef | grep 'ncat -lv 5009' | grep -v grep
    err=$?
    CHECK_RESULT "$err" 0 1 "fail to install ncat rules"
    if [ "$err" -eq 0 ]; then #if socket established unexpectedly, kill process
        kill -9 "$(ps -ef | grep 'ncat -lv' | grep -v grep | awk '{print $2}')"
    fi
    #valid port (host)
    ncat -lv 5005 > /home/secpaver_hostmsg &
    COUNT=0
    for ((i = 0; i < 100; i++)); do
        sleep 0.05
        COUNT=$(ps -ef | grep 5005 | grep -v grep -c)
        [ "$COUNT" -ne 0 ] && break
    done
    CHECK_RESULT "$COUNT" 0 1 "fail to install ncat rules"
    #valid port (client)
    echo "tcp socket message" | ncat localhost 5005
    CHECK_RESULT "$?" 0 0 "bind socket error"
    cat /home/secpaver_hostmsg
    grep "tcp socket message" /home/secpaver_hostmsg
    CHECK_RESULT "$?" 0 0 "fail to send message through tcp socket"
}

function post_test() {
    #Uninstall strategy
    uninstall_strategy testNet

    #clear temp file
    socket_file_clear
}

main "$@"
