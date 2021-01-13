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
# @Desc      :   skopeo test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    dnf install -y skopeo
}

function run_test() {
    skopeo list-tags --tls-verify=false docker://docker.io/nginx
    skopeo inspect --tls-verify=false docker://docker.io/nginx
}

main $@
