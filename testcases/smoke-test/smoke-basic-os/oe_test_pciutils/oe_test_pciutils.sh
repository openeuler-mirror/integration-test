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
# @Date      :   2020-07-20
# @License   :   Mulan PSL v2
# @Desc      :   pciutils test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    dnf install -y pciutils
}

function run_test() {
    lspci 2> error.log
    test -s error.log && return 1
    update-pciids
    lspci | grep "00:00.0"
}

function post_test() {
    test -f error.log && cat error.log && rm -f error.log
}

main $@
