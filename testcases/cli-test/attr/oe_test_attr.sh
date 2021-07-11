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
#@Date      	:   2021-07-11 14:49:00
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   command test attr
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    touch test && ln -s test test.lnk
    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test()
{
    LOG_INFO "Start to run test."
    attr -s "oe" -V "top" test
    CHECK_RESULT $?
    attr -g "oe" test|grep top
    CHECK_RESULT $?
    attr -l test |grep oe
    CHECK_RESULT $?
    attr -r oe test
    CHECK_RESULT $?
    attr -Lq -s "oe" -V "top" test.lnk
    CHECK_RESULT $?
    attr -Rq -s "oe" -V "betop" test
    CHECK_RESULT $?
    attr -Sq -s "oe" -V "beentop" test
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -f test.lnk test
    LOG_INFO "End to restore the test environment."
}

main "$@"
