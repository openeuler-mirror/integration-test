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
# @Date      :   2020-11-10
# @License   :   Mulan PSL v2
# @Desc      :   perf test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    dnf install -y perf file
}

function run_test() {
    perf list > txt 2> error.log
    test -s error.log && return 1

    timeout -k 15 1 perf record || ls perf.data
    file perf.data | grep -i data

    perf report -i perf.data > perf.log
    file perf.log | grep -i ASCII
}

function post_test() {
    rm -rf perf.data perf.log txt error.log
}

main $@
