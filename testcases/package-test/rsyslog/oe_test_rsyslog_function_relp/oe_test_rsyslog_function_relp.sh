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
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2020-08-03
# @License   :   Mulan PSL v2
# @Desc      :   Close the firewall, support relp protocol
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "net-tools rsyslog-relp"
    systemctl stop iptables
    SSH_CMD "
    dnf -y install rsyslog-relp 
    systemctl stop iptables" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat >/etc/rsyslog.d/server.conf <<EOF
    \$ModLoad imrelp 
    \$InputRELPServerRun 20514
EOF
    CHECK_RESULT $?
    systemctl restart rsyslog
    CHECK_RESULT $?
    netstat -anpt | grep 20514 | grep rsyslogd
    CHECK_RESULT $?
    time=$(date +%s%N | cut -c 9-13)
    SSH_CMD "
    echo '\$ModLoad omrelp\nlocal6.* :omrelp:${NODE1_IPV4}:20514' > /etc/rsyslog.d/client.conf
    systemctl restart rsyslog
    logger -t relp -p local6.err "relptest$time"
    " ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $?
    sleep 20
    grep "relptest$time" /var/log/messages
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    SSH_CMD "
    dnf -y remove rsyslog-relp
    rm -rf /etc/rsyslog.d/client.conf
    systemctl restart rsyslog" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    rm -rf /etc/rsyslog.d/server.conf
    systemctl restart rsyslog
    LOG_INFO "End to restore the test environment."
}
main "$@"
