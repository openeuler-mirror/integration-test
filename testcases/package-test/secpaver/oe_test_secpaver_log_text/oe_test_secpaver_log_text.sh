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
# @Desc      :   Secpaver log test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    # Install pavd
    DNF_INSTALL secpaver && systemctl start pavd
    # 原本的日志文件备份,创建一个空白的新日志文件
    cp -a /var/log/secpaver/pavd.log /var/log/secpaver/pavd.swap.log
    echo 0> /var/log/secpaver/pavd.log
}

function run_test() {
    # correct log
    pav project list
    grep "error" /var/log/secpaver/pavd.log
    CHECK_RESULT "$?" 0 1  "log error"
    # error log 
    mv /var/local/secpaver/projects/ /var/local/secpaver/projects_r/
    pav project list
    cat /var/log/secpaver/pavd.log
    grep "error" /var/log/secpaver/pavd.log
    CHECK_RESULT "$?" 0 0 "log error"
    # recover
    mv /var/local/secpaver/projects_r/ /var/local/secpaver/projects/
    systemctl restart pavd
    grep -E 'viewsec|viewSec|vsec|vsecd' /var/log/secpaver/pavd.log
    CHECK_RESULT "$?" 0 1 "remained viewsec keywords in secpaver log"
    systemctl stop pavd
}

function post_test() {
    # delete temp log
    echo 0> /var/log/secpaver/pavd.log
    cat /var/log/secpaver/pavd.swap.log > /var/log/secpaver/pavd.log
    rm -rf /var/log/secpaver/pavd.swap.log
}

main "$@"
