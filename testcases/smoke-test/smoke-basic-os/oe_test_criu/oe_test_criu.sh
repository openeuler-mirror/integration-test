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
# @Author    :   lutianxiong
# @Contact   :   lutianxiong@huawei.com
# @Date      :   2020-11-20
# @License   :   Mulan PSL v2
# @Desc      :   criu test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"
out_file="output.txt"
last_num=20

function pre_test() {
    dnf install -y criu gcc
    mkdir checkpoint_demo
}

function run_test() {
    gcc -o demo demo.c
    ./demo &
    pid=$!

    sleep 1
    criu dump -D `pwd`/checkpoint_demo -j -t $pid
    ps aux | grep "demo" | grep -w $pid && return 1
    let num1=`cat $out_file | tail -1`

    criu restore -D `pwd`/checkpoint_demo -j
    let num2=num1+1
    cat $out_file | grep -w $num2
    cat $out_file | grep -w $last_num
}

function post_test() {
    rm -rf checkpoint_demo demo $out_file
}

main $@
