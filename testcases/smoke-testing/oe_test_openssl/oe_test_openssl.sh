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
# @Date      :   2020-10-10
# @License   :   Mulan PSL v2
# @Desc      :   openssl test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"
encry_file=/tmp/encry_$$
decry_file=/tmp/decry_$$

function pre_test() {
    dnf install -y openssl
}

function run_test() {
    openssl enc -des3 -pbkdf2 -pass pass:abc123 -in /etc/fstab -out $encry_file
    diff /etc/fstab $encry_file && return 1
    openssl enc -d -des3 -pbkdk2 -pass pass:abc123 -in $encry_file -out $decry_file
    diff /etc/fstab $decry_file

    openssl req -newkey ras:2048 -nodes -keyout rsa_private.key -x509 -out cert.crt -subj "/C=CN/O=openeuler/OU=oec"
    openssl x509 -in cert.crt -noout -text | grep "CN" | grep "openeuler" | grep "oec"
}

function post_test() {
    rm -rf $encry_file $decry_file
    rm -rf cert.crt rsa_private.key
}

main $@
