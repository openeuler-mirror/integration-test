#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2020-10-23
#@License       :   Mulan PSL v2
#@Desc          :   pcp testing(pmlogger_daily_report)
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "pcp pcp-zeroconf"
    systemctl enable pmcd
    systemctl start pmcd
    systemctl enable pmlogger
    systemctl start pmlogger
    SLEEP_WAIT 10
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    /usr/libexec/pcp/bin/pmlogger_daily_report -a yesterday
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily_report -f sar5
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily_report -h localhost
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily_report -l dailyReport.txt
    CHECK_RESULT $?
    test -f dailyReport.txt
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily_report -p
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily_report -o /var/log/pcp/sa/
    CHECK_RESULT $?
    test -d /var/log/pcp/sa
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily_report -t 30
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily_report -A
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily_report -V
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f sar5 dailyReport.txt
    rm -rf /var/log/pcp/sa
    LOG_INFO "End to restore the test environment."
}

main "$@"
