#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   oe_test_dnf_package_group_operate
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2021.4-9
# @License   :   Mulan PSL v2
# @Desc      :   Package group operations
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
	LOG_INFO "Start executing testcase."
	dnf group install -y "Development Tools" --nobest 
	LOG_INFO "End of testcase execution."
}

function run_test() {
	LOG_INFO "Start executing testcase."
	dnf groups summary | grep "Available Groups"
	CHECK_RESULT $?
	dnf group list | grep "Available Environment Groups"
	CHECK_RESULT $?
	dnf group info "Development Tools" | grep "Group: Development Tools"
	CHECK_RESULT $?
	dnf group remove -y "Development Tools"
	CHECK_RESULT $?
	LOG_INFO "End of testcase execution."
}

main $@
