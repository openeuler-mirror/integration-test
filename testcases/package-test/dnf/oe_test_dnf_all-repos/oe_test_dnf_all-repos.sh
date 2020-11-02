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
# @Desc      :   test all oe repos
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    dnf -y --repo=OS install vim
    CHECK_RESULT $? 0 0
    dnf list --installed | grep vim-enhanced | grep @OS
    CHECK_RESULT $? 0 0

    dnf -y --repo=everything install tree
    CHECK_RESULT $? 0 0
    dnf list --installed | grep tree | grep @everything
    CHECK_RESULT $? 0 0

    dnf -y --repo=EPOL list | grep EPOL
    CHECK_RESULT $? 0 0

    dnf -y --repo=debuginfo list | grep debuginfo
    CHECK_RESULT $? 0 0
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dnf -y remove tree vim
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
