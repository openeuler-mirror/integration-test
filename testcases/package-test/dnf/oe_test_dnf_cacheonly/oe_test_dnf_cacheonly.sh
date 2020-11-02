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
# @License   :   Mulan PSL v2
# @Desc      :   Test "-C,--cacheonly" option
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    dnf makecache
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dnf -C repoquery kernel
    CHECK_RESULT $? 0 0
    dnf clean all
    #清理缓存后再仅使用缓存
    dnf -C repoquery kernel 2>&1 | grep Error
    CHECK_RESULT $? 0 0
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dnf clean all
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
