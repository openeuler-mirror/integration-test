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
# @Date      :   2020/5/12
# @Desc      :   Test "dnf list" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    dnf list --all
    CHECK_RESULT $? 0 0
    dnf list --installed
    CHECK_RESULT $? 0 0
    dnf list --available
    CHECK_RESULT $? 0 0
    dnf list --extras
    CHECK_RESULT $? 0 0
    dnf list --obsoletes
    CHECK_RESULT $? 0 0
    dnf list --recent
    CHECK_RESULT $? 0 0
    dnf list --upgrades
    CHECK_RESULT $? 0
    dnf list --autoremove
    CHECK_RESULT $? 0 0
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Need't to restore the tet environment."
}

main "$@"
