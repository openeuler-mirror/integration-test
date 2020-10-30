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
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-mv
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    ls /home/test1 && rm -rf /home/test1
    ls /home/test2 && rm -rf /home/test2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    mkdir test1
    mv test1 /home
    ls /home/test1
    CHECK_RESULT $?

    mv /home/test1 /home/test2 && ls /home/test2
    CHECK_RESULT $?
    rm -rf /home/test2

    mkdir test2 && mv -f test2 /home
    ls /home/test2
    CHECK_RESULT $?

    mv --help | grep "Usage"
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /home/test2
    LOG_INFO "Finish environment cleanup!"
}

main $@
