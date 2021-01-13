#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2021-01-10
# @License   :   Mulan PSL v2
# @Desc      :   lzo test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"
origin_file="/etc/openEuler-release"

function pre_test() {
    dnf install -y lzop
}

function run_test() {
    lzop -o test.lzo $origin_file
    diff test.lzo $origin_file && return 1
    lzop -t test.lzo
    lzop -l test.lzo
    lzop -d test.lzo
    diff test $origin_file
}

function post_test() {
    rm -rf test test.lzo
}

main $@
