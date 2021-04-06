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
#@Desc          :   pcp testing(pmlogger_daily)
#####################################

source "common_pcp.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    /usr/libexec/pcp/bin/pmlogger_daily -c /etc/pcp/pmlogger/control.d/local
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily -f
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily -k 2
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily -K
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily -l t1.txt
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily -m public@openeuler.io
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily -M
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily -N | grep 'pmlogger'
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pmlogger_daily -o
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f t1.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
