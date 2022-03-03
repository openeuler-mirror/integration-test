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
# @Desc      :   Icmp socket policy test
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
    #valid port (host)
    ping localhost -w 5 > /home/secpaver_hostmsg
    CHECK_RESULT "$?" 0 0 "fail to install ncat rules"
    cat /home/secpaver_hostmsg
    getcap /bin/ping
    ls -lZ /bin/ping
    grep "64 bytes from localhost" /home/secpaver_hostmsg
    CHECK_RESULT "$?" 0 0 "fail to send message through icmp socket"
}

function post_test() {
    #kill udp socket process
    kill -9 "$(ps -ef | grep 'ping localhost' | grep -v grep | awk '{print $2}')"

    #Uninstall strategy
    uninstall_strategy testNet

    #clear temp file
    socket_file_clear
}

main "$@"
