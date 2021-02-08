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
#@Date          :   2020-10-29
#@License       :   Mulan PSL v2
#@Desc          :   (pcp-manager) pmmgr
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "pcp pcp-manager"
    systemctl enable pmcd
    systemctl start pmcd
    systemctl enable pmlogger
    systemctl start pmlogger
    SLEEP_WAIT 10
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup /usr/libexec/pcp/bin/pmmgr -c /etc/pcp/pmmgr/test >pmmgr_t1 2>&1 &
    SLEEP_WAIT 2 "grep 'Log started' pmmgr_t1"
    CHECK_RESULT $?
    nohup /usr/libexec/pcp/bin/pmmgr -p 30 >pmmgr_t2 2>&1 &
    SLEEP_WAIT 2 "grep 'pmmgr' pmmgr_t2"
    CHECK_RESULT $?
    nohup /usr/libexec/pcp/bin/pmmgr -U pcp >pmmgr_t3 2>&1 &
    SLEEP_WAIT 2 "grep '/etc/pcp/pmmgr/test' pmmgr_t3"
    CHECK_RESULT $?
    nohup /usr/libexec/pcp/bin/pmmgr -l /home/zjl/ >pmmgr_t4 2>&1 &
    SLEEP_WAIT 2 "grep 'new hostid' pmmgr_t4"
    CHECK_RESULT $?
    nohup /usr/libexec/pcp/bin/pmmgr -v >pmmgr_t5 2>&1 &
    SLEEP_WAIT 2 "grep 'Log finished' pmmgr_t5"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f pmmgr_t*
    kill -9 $(pgrep -f /usr/libexec/pcp/bin/pmmgr)
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
