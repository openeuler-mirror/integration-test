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
# @Desc      :   rsync test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"
src_dir="$(pwd)/dir1_$$"
des_dir="$(pwd)/dir2_$$"
conf_file="/etc/rsyncd.conf"
se_stat="Enforcing"

function pre_test() {
    dnf install -y rsync
    cp $conf_file conf_bak
    mkdir -p $src_dir $des_dir
    se_stat="$(getenforce)"
}

function run_test() {
    cp -raf /lib/udev/* $src_dir
    touch $des_dir/file_$$
    rsync -a --delete $src_dir $des_dir
    diff $src_dir $des_dir -r
    
    rm -rf $des_dir/*
    echo -e "[test]\npath = $des_dir\nread only = no\nuid = root" > $conf_file
    systemctl restart rsyncd
    setenforce 0
    rsync -a $0 localhost::test
    diff $0 $des_dir/$0 
}

function post_test() {
    systemctl stop rsyncd
    mv conf_bak $conf_file 
    rm -rf $src_dir $des_dir
    setenforce $se_stat
}

main $@
