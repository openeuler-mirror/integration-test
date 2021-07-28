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
#@Author    	:   jhon-hsu
#@Contact   	:   lookforwardxu@163.com
#@Date      	:   2021-07-15 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   test command pngquant
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params()
{
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    mkdir output_test
    wget -P ./ https://pngquant.org/Ducati_side_shadow.png && mv Ducati_side_shadow.png test.png
    cp test.png test-copy.png
    DNF_INSTALL "pngquant libimagequant"

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    
    pngquant --help
    CHECK_RESULT $? 0 0 "Failed to run command: pngquant --help"

    pngquant test.png --verbose
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --verbose"

    rm -f ./test-fs8.png
    pngquant test.png
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant test.png"

    pngquant - <test.png >test-stdout.png
    CHECK_RESULT "$(ls | grep -cE 'test-stdout.png')" 1 0 "Failed to test stdin and stdout"
   
    rm -f ./test-fs8.png
    pngquant test.png test-copy.png
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png|test-copy-fs8.png')" 2 0 "Failed to test more than one file"

    rm -f ./test-fs8.png
    pngquant --posterize 3 test.png
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --posterize"

    rm -f ./test-fs8.png
    pngquant --strip test.png
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --strip"
    
    pngquant test.png --ext .demo
    CHECK_RESULT "$(ls | grep -cE 'test.demo')" 1 0 "Failed to run command: pngquant --ext"

    pngquant test.png --output ./output_test/test_output.png
    CHECK_RESULT "$(ls ./output_test | grep -cE 'test_output.png')" 1 0 "Failed to run command: pngquant --output"
    
    rm -f ./test-fs8.png
    pngquant 64 test.png
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to test option [ncolors]"

    pngquant --force test.png
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --force"
    
    rm -f ./test-fs8.png
    pngquant --skip-if-larger test.png
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --skip-if-larger"
    
    pngquant --nofs test.png
    CHECK_RESULT "$(ls | grep -cE 'test-or8.png')" 1 0 "Failed to run command: pngquant --nofs"
    
    rm -f ./test-fs8.png
    pngquant test.png --quality 50
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --quality"

    rm -f ./test-fs8.png
    pngquant test.png --speed 5 
    CHECK_RESULT "$(ls | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --speed"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    
    DNF_REMOVE
    rm -rf ./test* ./output_test/

    LOG_INFO "End to restore the test environment."
}

main "$@"
