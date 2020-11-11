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
# @Date      :   2020/5/12
# @Desc      :   Test "dnf clean" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    dnf makecache
    ls /var/cache/dnf/*.solv
    CHECK_RESULT $? 0 0
    dnf clean dbcache
    CHECK_RESULT $? 0 0
    ls /var/cache/dnf/*.solv
    CHECK_RESULT $? 2 0

    dnf makecache
    dnf clean expire-cache | grep "Cache was expired"
    CHECK_RESULT $? 0 0

    dnf makecache
    dnf clean metadata | grep "Cache was expired"
    CHECK_RESULT $? 0 0
    ls /var/cache/dnf/*.solv
    CHECK_RESULT $? 2 0

    dnf --downloadonly install -y tree
    find /var/cache/dnf -name 'tree*' | grep tree
    CHECK_RESULT $? 0 0
    dnf clean packages
    CHECK_RESULT $? 0 0
    find /var/cache/dnf -name 'tree*' | grep tree
    CHECK_RESULT $? 1 0

    dnf --downloadonly install -y tree
    find /var/cache/dnf -name 'tree*' | grep tree
    CHECK_RESULT $? 0 0
    dnf makecache
    ls /var/cache/dnf/*.solv
    CHECK_RESULT $? 0 0
    dnf clean all
    CHECK_RESULT $? 0 0
    find /var/cache/dnf -name 'tree*' | grep tree
    CHECK_RESULT $? 1 0
    ls /var/cache/dnf/*.solv
    CHECK_RESULT $? 2 0
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Need't to restore the tet environment."
}

main "$@"
