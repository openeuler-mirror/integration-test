#!/usr/bin/bash

# Copyright (c) 2020 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   oe_test_system_install_package
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Installation instructions
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "This test case does not require environment preparation."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    DNF_INSTALL iSulad
    CHECK_RESULT $?

    DNF_INSTALL syscontainer-tools
    CHECK_RESULT $?

    DNF_INSTALL lxcfs
    CHECK_RESULT $?

    DNF_INSTALL lxcfs-tools
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "iSulad syscontainer-tools lxcfs lxcfs-tools"
    LOG_INFO "Finish environment cleanup."
}

main $@
