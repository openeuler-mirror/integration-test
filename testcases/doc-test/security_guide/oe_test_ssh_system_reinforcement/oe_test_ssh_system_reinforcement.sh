#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/5/28
# @License   :   Mulan PSL v2
# @Desc      :   Sshd system reinforcement test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start environmental preparation."
    grep "^SyslogFacility AUTH" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^LogLevel VERBOSE" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^X11Forwarding no" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^IgnoreRhosts yes" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^RhostsRSAAuthentication no" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^Subsystem sftp /usr/libexec/openssh/sftp-server -l INFO -f AUTH" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^HostbasedAuthentication no" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^ClientAliveCountMax 0" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^MACs hmac-sha2-512,hmac-sha2-512-etm@openssh.com,hmac-sha2-256,hmac-sha2-256-etm@openssh.com" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^AllowTcpForwarding no" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^Subsystem sftp" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^GatewayPorts no" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^PermitTunnel no" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group-exchange-sha256" /etc/ssh/sshd_config ||
        grep "^KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256" /etc/ssh/sshd_config
    CHECK_RESULT $?
    grep "^KexAlgorithms" /etc/ssh/ssh_config
    CHECK_RESULT $? 0 1
    grep "^VerifyHostKeyDNS" /etc/ssh/ssh_config
    CHECK_RESULT $? 0 1
    LOG_INFO "End of environmental preparation!"
}

function post_test() {
    LOG_INFO "This test case do not require environmental to cleanup!"
}

main "$@"
