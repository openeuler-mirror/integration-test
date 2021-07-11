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
#@Author    	:   mcfd
#@Contact   	:   mcfd@qq.com
#@Date      	:   2021/7/11
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Testing uuid 
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 需要预加载的数据、参数配置
function config_params()
{
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

# 测试对象、测试需要的工具等安装准备
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    dnf install uuid -y

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test()
{
    LOG_INFO "Start to run test."

    # 测试命令：uuid
    uuid
    CHECK_RESULT 0

    # 测试生成情况
    STRING=uuid
    if [ -n "$STRING" ]; then

    CHECK_RESULT 0 

    fi


    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test()
{
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "Need't to restore the tet environment."

    LOG_INFO "End to restore the test environment."
}

main "$@"
