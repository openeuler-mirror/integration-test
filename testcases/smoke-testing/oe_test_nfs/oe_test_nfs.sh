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
# @Date      :   2020-07-20
# @License   :   Mulan PSL v2
# @Desc      :   nfs test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"
test_user=nfs_test_$$
server_dir=/home/nfs_server_$$
client_dir=/home/nfs_client_$$

function pre_test() {
    dnf install -y nfs-utils nfs4-acl-tools
    useradd $test_user
    mkdir $server_dir $client_dir
    test -f /etc/exports && cp /etc/exports .
    return 0
}

function run_test() {
    echo "$server_dir *(rw,sync,no_root_squash)" >> /etc/exports
    systemctl restart nfs-server
    showmount -e localhost | grep -w "$server_dir"
    mount -t nfs4 localhost:$server_dir $client_dir

    echo "$$" > $client_dir/file
    diff $server_dir/file $client_dir/file

    chmod 640 $client_dir/file
    sudo -u $test_user cat $client_dir/file 2> error.log && return 1 
    cat error.log | grep "Permission denied"

    uid=$(id -u $test_user)
    nfs4_setfacl -a "A::${uid}:r" $client_dir/file
    nfs4_getfacl $client_dir/file | grep "A::${uid}:r"
    sudo -u $test_user cat $client_dir/file
    umount $client_dir
}

function post_test() {
    set +e
    umount $client_dir
    rm -rf $client_dir $server_dir
    userdel -r $test_user
    rm -f error.log
    test -f exports && mv exports /etc/exports
}

main $@
