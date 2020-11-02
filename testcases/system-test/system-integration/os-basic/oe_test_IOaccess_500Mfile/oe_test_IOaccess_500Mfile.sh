#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   500M file continuous copy, create, compress, decompress test
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start to run test."
    #500M
    for i in $(seq 1 10); do
        dd if=/dev/zero of=test1 bs=1M count=500
        CHECK_RESULT $?
        ls -l test1 | awk '{print$5}' | grep -w 524288000
        CHECK_RESULT $?
    done

    file_size=$(ls -l test1 | awk '{print$5}')

    for i in $(seq 1 10); do
        rm -rf test2
        cp test1 test2
        CHECK_RESULT $?
        ls -l test2 | grep ${file_size}
        CHECK_RESULT $?
    done

    for i in $(seq 1 10); do
        rm -rf test1.zip
        zip test1.zip test1
        CHECK_RESULT $?
        ls test1.zip
        CHECK_RESULT $?
    done

    for i in $(seq 1 10); do
        rm -rf test1
        unzip test1.zip
        CHECK_RESULT $?
        ls -l test1 | grep ${file_size}
        CHECK_RESULT $?
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test1 test2 test1.zip
    LOG_INFO "End to restore the test environment."
}

main "$@"
