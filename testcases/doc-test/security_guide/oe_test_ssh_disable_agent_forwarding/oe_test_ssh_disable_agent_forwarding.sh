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
# @Date      :   2020/6/4
# @License   :   Mulan PSL v2
# @Desc      :   Disable SSH agent forwarding
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    cp /etc/ssh/ssh_config /etc/ssh/ssh_config-bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep "^AllowAgentForwarding yes" /etc/ssh/sshd_config
    CHECK_RESULT $?
    expect <<EOF
        set timeout 15
        spawn ssh-keygen
        expect {
            "save the key" {
                send "\\r"
            }
        }
        expect {
            "Enter passphrase" {
                send "\\r"
            }
        }
        expect {
                "Enter same passphrase again" {
                send "\\r"
                }
        }
        expect eof
EOF
    ls -l /root/.ssh | grep id_rsa
    CHECK_RESULT $?
    expect <<EOF
        set timeout 15
        spawn ssh-copy-id -i /root/.ssh/id_rsa.pub ${NODE2_USER}@${NODE2_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password" {
                send "${NODE2_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    expect <<EOF
        set timeout 15
        spawn ssh-copy-id -i /root/.ssh/id_rsa.pub ${NODE3_USER}@${NODE3_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password" {
                send "${NODE2_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/root/.ssh/authorized_keys /home ${NODE2_PASSWORD}
    grep ssh-rsa /home/authorized_keys
    CHECK_RESULT $?
    rm -rf /home/authorized_keys
    SSH_SCP ${NODE3_USER}@${NODE3_IPV4}:/root/.ssh/authorized_keys /home ${NODE3_PASSWORD}
    grep ssh-rsa /home/authorized_keys
    CHECK_RESULT $?
    sed -i 's/#   ForwardAgent no/ForwardAgent yes/g' /etc/ssh/ssh_config
    systemctl restart sshd
    grep "^ForwardAgent yes" /etc/ssh/ssh_config
    CHECK_RESULT $?
    SSH_CMD "touch /home/test.txt" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    expect <<EOF
        set timeout 15
        log_file testlog
        spawn scp ${NODE2_USER}@${NODE2_IPV4}:/home/test.txt ${NODE3_USER}@${NODE3_IPV4}:/home
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect eof
EOF
    grep "password:" testlog
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    mv /etc/ssh/ssh_config-bak /etc/ssh/ssh_config
    systemctl restart sshd
    SSH_CMD "rm -rf /root/.ssh/authorized_keys" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "rm -rf /home/test.txt" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "rm -rf /root/.ssh/authorized_keys" ${NODE3_IPV4} ${NODE3_PASSWORD} ${NODE3_USER}
    rm -rf /root/.ssh/id_rsa /root/.ssh/id_rsa.pub testlog /home/authorized_keys
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
