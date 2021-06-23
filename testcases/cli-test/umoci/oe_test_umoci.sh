#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wss1235
#@Contact   	:   2115994138@qq.com
#@Date      	:   2021-06-23 11:13:00
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   command test umoci
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "umoci"
    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test()
{
    LOG_INFO "Start to run test."
    umoci init --layout new_image 
    ls new_image 
    CHECK_RESULT $? 
    umoci new --image new_image:latest
    CHECK_RESULT $?
    umoci list --layout new_image |grep "latest"
    CHECK_RESULT $? 
    umoci config --author="test <test@xxx.com>" --image new_image
    CHECK_RESULT $?
    umoci rm --image new_image:latest
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf new_image
    DNF_REMOVE umoci
    LOG_INFO "End to restore the test environment."
}

main "$@"
