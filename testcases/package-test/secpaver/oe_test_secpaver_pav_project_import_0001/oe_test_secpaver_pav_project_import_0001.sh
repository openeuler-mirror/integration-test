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
# @Desc      :   pav project import cmd test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    DNF_INSTALL secpaver && systemctl start pavd
    pav project create "$project_name" .
    zip -r "$project_name".zip "$project_name"/
}

function run_test() {
    ls "$project_name".zip
    CHECK_RESULT $? 0 0 "pav project create failed"
    pav project list | grep "$project_name" && pav project delete "$project_name"
    pav project import "$project_name".zip > result1 2>&1
    grep 'Finish importing project' result1
    CHECK_RESULT $? 0 0 "import project failed"
    pav project import "$project_name".zip > result2 2>&1
    grep 'project exists' result2
    CHECK_RESULT $? 0 0 "import existed project failed"
    pav project import "$project_name".zip -f > result3 2>&1
    grep 'Finish importing project' result3
    CHECK_RESULT $? 0 0 "force import existed project failed"
}

function post_test() {
    pav project delete "$project_name"
    rm -rf proj*
    DNF_UNINSTALL secpaver 1
}

main "$@"
