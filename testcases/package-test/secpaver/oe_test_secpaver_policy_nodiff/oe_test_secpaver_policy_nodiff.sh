#!/usr/bin/bash

#@ License : Mulan PSL v2
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   zengxianjun
# @Contact   :   mistachio@163.com
# @Date      :   2022/03/02
# @Desc      :   exported policy file integrity test
# ##################################

source ../common/config_secpaver.sh
set +e
WDIR=$(pwd)

function pre_test() {
    DNF_INSTALL secpaver && systemctl start pavd
}

function run_test() {
    mkdir policy1 policy2
    pav project import ../common/testNet.zip
    pav project build -r testNet --engine selinux
    pav policy export testNet_selinux ./policy1
    pav policy export testNet_selinux ./policy2
    md5sum ./policy1/testNet_selinux.zip | awk '{$1}' > checksum_1
    md5sum ./policy2/testNet_selinux.zip | awk '{$1}' > checksum_2
    diff checksum_1 checksum_2
    CHECK_RESULT "$?" 0 0 "build consistent policy."
}

function post_test() {
    cd "$WDIR" || exit 1
    rm -rf ./policy*
    DNF_UNINSTALL secpaver 1
}

main "$@"
