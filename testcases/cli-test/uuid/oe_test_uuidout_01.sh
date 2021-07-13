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
#@Author    	:   mcfdd
#@Contact   	:   990773468@qq.com
#@Date      	:   2021-07-13 10:11:00
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   command  test uuid
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


# 测试对象、测试需要的工具等安装准备
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "uuid"

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test()
{
    LOG_INFO "Start to run test."
    uuid
    CHECK_RESULT $?
    uuid -v1
    CHECK_RESULT $?
    uuid -v3 ns:URL https://kernel.org
    CHECK_RESULT $?
    uuid -v4
    CHECK_RESULT $?
    uuid -v5 ns:URL https://kernel.org
    CHECK_RESULT $?
    uuid -m
    CHECK_RESULT $?
    uuid -n2
    CHECK_RESULT $?
    uuid -n3 -1
    CHECK_RESULT $?
    uuid -F bin
    CHECK_RESULT $?
    uuid -F str
    CHECK_RESULT $?
    uuid -F siv
    CHECK_RESULT $?
    uuid -o 1.txt
    ls | grep 1.txt
    CHECK_RESULT $?
    uuid -h
    CHECK_RESULT $?
    uuid -d b847136c-e382-11eb-8b80-1b1b93efe3b6
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm 1.txt
    DNF_REMOVE "uuid"

    LOG_INFO "End to restore the test environment."
}

main "$@"
