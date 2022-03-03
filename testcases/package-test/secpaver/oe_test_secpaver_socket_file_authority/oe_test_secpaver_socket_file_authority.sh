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
# @Date      :   2022/03/03
# @Desc      :   /var/run/secpaver/pavd.sock authourity test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    #Install pavd
    DNF_INSTALL secpaver && systemctl start pavd

    # Add user
    useradd userTest1
}

function run_test() {
    # check socket file mode
    mode=$(stat -c %a /var/run/secpaver/pavd.sock)
    user=$(stat -c %U /var/run/secpaver/pavd.sock)
    CHECK_RESULT "$mode" 600 0 "Socket file mode error."
    CHECK_RESULT "$user" "root" 0 "invalid owner of socket file."
    # normal user read socket file
    su - userTest1 -c "head -n1 /var/run/secpaver/pavd.sock" > output
    line=$(wc -l output | awk '{print $1}')
    CHECK_RESULT "$line" 0 0 "invalid authority of socket file."
}

function post_test() {
    # delete temp file
    rm -rf output

    # delete user
    userdel -r userTest1
}

main "$@"
