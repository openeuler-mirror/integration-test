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
# @Date      :   2022/03/01
# @Desc      :   pav project import large project file
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    DNF_INSTALL secpaver && systemctl start pavd
    dd if=/dev/zero of="$project_name".zip bs=1M count=10
}

function run_test() {
    ls "$project_name".zip
    CHECK_RESULT $? 0 0 "failed to create zip file"
    pav project import "$project_name".zip > result 2>&1
    CHECK_RESULT $? 0 1 "pav project import failed"
    grep 'the file size must be smaller than' result
    CHECK_RESULT $? 0 0 "error print"
}

function post_test() {
    pav project delete "$project_name"
    rm -rf result* proj*
    DNF_UNINSTALL secpaver 1
}

main "$@"
