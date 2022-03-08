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
# @Date      :   2022/02/28
# @Desc      :   Check secpaver config file authority
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    # Install pavd
    DNF_INSTALL secpaver && systemctl start pavd

    # Add user
    useradd userTest1
}

function run_test() {
    # check config file mode
    mode=$(stat -c %a /etc/secpaver/pavd/config.json)
    user=$(stat -c %U /etc/secpaver/pavd/config.json)
    CHECK_RESULT "$mode" 600 0 "invalid mode of config file."
    CHECK_RESULT "$user" "root" 0 "invalid owner of config file."
    # normal user read config file
    su - userTest1 -c "head -n1 /etc/secpaver/pavd/config.json" > output
    line=$(wc -l output | awk '{print $1}')
    CHECK_RESULT "$line" 0 0 "invalid authority of config file."
}

function post_test() {
    # delete temp file
    rm -rf output

    # delete user
    userdel -r userTest1
}

main "$@"
