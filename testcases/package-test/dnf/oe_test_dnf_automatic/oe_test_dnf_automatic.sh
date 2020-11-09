#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/5/13
# @License   :   Mulan PSL v2
# @Desc      :   Test dnf-automatic services
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    systemctl enable dnf-automatic-notifyonly.timer
    CHECK_RESULT $? 0 0
    systemctl start dnf-automatic-notifyonly.timer
    CHECK_RESULT $? 0 0
    systemctl enable dnf-automatic-download.timer
    CHECK_RESULT $? 0 0
    systemctl start dnf-automatic-download.timer
    CHECK_RESULT $? 0 0
    systemctl enable dnf-automatic-install.timer
    CHECK_RESULT $? 0 0
    systemctl start dnf-automatic-install.timer
    CHECK_RESULT $? 0 0
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start restore the test environment."
    systemctl stop dnf-automatic-notifyonly.timer
    systemctl disable dnf-automatic-notifyonly.timer
    systemctl stop dnf-automatic-download.timer
    systemctl disable dnf-automatic-download.timer
    systemctl stop dnf-automatic-install.timer
    systemctl disable dnf-automatic-install.timer
    LOG_INFO "End of restore the test environment."
}

main "$@"
