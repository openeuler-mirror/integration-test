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
# @Desc      :   Test gpgcheck
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    if cat /etc/yum.repos.d/openEuler.repo | grep "gpgcheck=1"; then
        dnf -y install tree
        CHECK_RESULT $? 0 0
        rpm -q tree
        CHECK_RESULT $? 0 0
        dnf -y remove tree
    else
        cat /etc/yum.repos.d/openEuler.repo | grep "gpgcheck=1"
        CHECK_RESULT $? 1 0
        dnf -y install tree
        CHECK_RESULT $? 0 0
        rpm -q tree
        CHECK_RESULT $? 0 0
    fi
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dnf -y remove tree
    LOG_INFO "End of restore the test environment."
}

main "$@"
