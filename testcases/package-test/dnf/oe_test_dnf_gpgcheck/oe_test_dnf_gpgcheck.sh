#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   zengcongwei
# @Contact   :   735811396@qq.com
# @Date      :   2020/5/13
# @License   :   Mulan PSL v2
# @Desc      :   Test gpgcheck
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    if cat /etc/yum.repos.d/openEuler.repo | grep -A 4 "name=OS" | grep "gpgcheck=1"; then
        dnf --repo=OS install -y tree
        CHECK_RESULT $? 0 0
        rpm -q tree
        CHECK_RESULT $? 0 0
    else
        line=$(cat /etc/yum.repos.d/openEuler.repo | grep -nA4 "name=OS" | grep "gpgcheck" | awk -F "-" '{print $1}')
        url=$(cat /etc/yum.repos.d/openEuler.repo | grep -nA4 "name=OS" | grep baseurl | awk -F = '{print $2}')
        sed -i "${line}c gpgcheck=1" /etc/yum.repos.d/openEuler.repo
        if ! cat /etc/yum.repos.d/openEuler.repo | grep -A 4 "name=OS" | grep "gpgkey"; then
            sed -i "${line}a\gpgkey=${url}RPM-GPG-KEY-openEuler" /etc/yum.repos.d/openEuler.repo
            flag=1
        fi
        dnf --repo=OS install -y tree
        CHECK_RESULT $? 0 0
        rpm -q tree
        CHECK_RESULT $? 0 0
        sed -i "${line}c gpgcheck=0" /etc/yum.repos.d/openEuler.repo
        if [ ${flag} == 1 ]; then
            line1=$(( line +1 ))
            sed -i "${line1}d" /etc/yum.repos.d/openEuler.repo
        fi
    fi
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dnf -y remove tree
    LOG_INFO "End of restore the test environment."
}

main "$@"
