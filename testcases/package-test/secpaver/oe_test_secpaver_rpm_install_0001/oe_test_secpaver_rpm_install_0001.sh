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
# @Desc      :   pavd service test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    DNF_INSTALL secpaver && systemctl start pavd
}

function run_test() {
    # status
    systemctl status pavd > stat
    grep "Active: active (running)" stat
    CHECK_RESULT "$?" 0 0 "Error in pavd service status"
    # version
    ver=$(pav -v | awk '{print $3}')
    rpm -qa secpaver > rpm_msg
    grep "${ver}" rpm_msg
    CHECK_RESULT "$?" 0 0 "Error version"
    # config file mode
    mode=$(stat -c %a /etc/secpaver/pavd/config.json)
    CHECK_RESULT "$mode" 600 0 "Access permission of config file should be 600"
    # restart pavd
    systemctl restart pavd
    CHECK_RESULT "$?" 0 0 "Fail to restart pavd"
    # stop pavd
    systemctl stop pavd
    CHECK_RESULT "$?" 0 0 "Fail to stop pavd"
}

function post_test() {
    DNF_UNINSTALL secpaver 1
}

main "$@"
