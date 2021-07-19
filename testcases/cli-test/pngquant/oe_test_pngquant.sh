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
#@Author    	:   jhon-hsu
#@Contact   	:   lookforwardxu@163.com
#@Date      	:   2021-07-15 09:39:43
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   test command pngquant
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

    mkdir output_test
    wget https://pngquant.org/Ducati_side_shadow.png && mv Ducati_side_shadow.png test.png
    DNF_INSTALL pngquant
    DNF_INSTALL libimagequant

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test()
{
    LOG_INFO "Start to run test."
    
    pngquant --help
    CHECK_RESULT $? 0 0 "Failed to run command: pngquant --help"

    pngquant test.png
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant test.png"

    pngquant test.png --ext .demo
    CHECK_RESULT "$(ls | grep -cE 'test.demo')" 1 0 "Failed to run command: pngquant --ext"

    pngquant test.png --output ./output_test/test_output.png
    CHECK_RESULT "$(ls ./output_test | grep -cE 'test_output.png')" 1 0 "Failed to run command: pngquant --output"
    
    rm -rf ./test-fs8.png
    pngquant test.png --quality 50
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --quality"

    rm -rf ./test-fs8.png
    pngquant test.png --speed 5 
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --speed"

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf test.png test.demo test-fs8.png ./output_test/

    LOG_INFO "End to restore the test environment."
}

main "$@"
