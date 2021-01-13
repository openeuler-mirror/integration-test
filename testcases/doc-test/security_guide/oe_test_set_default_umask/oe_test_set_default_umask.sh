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
# @Date      :   2020/05/28
# @License   :   Mulan PSL v2
# @Desc      :   Set the user's default umask value to 077
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    SSH_CMD "cp /etc/bashrc /etc/bashrc-bak;rm -rf /home/test1 /home/log /home/test2;ls /etc/profile.d/ >/home/tmp;while read line;do cp /etc/profile.d/\${line} /etc/profile.d/\${line}-bak;done </home/tmp" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    SSH_CMD "echo 'umask 0077' >>/etc/bashrc" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "while read line;do echo 'umask 0077' >>/etc/profile.d/\${line};done </home/tmp" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "mkdir /home/test1;ls -l /home | grep test1" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} | tail -n 1 | grep 'drwx\-\-\-\-\-\-'
    CHECK_RESULT $?
    SSH_CMD "touch /home/test2;ls -l /home/test2" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} | tail -n 1 | grep '\-rw\-\-\-\-\-\-\-'
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}
function post_test() {
    LOG_INFO "start environment cleanup."
    SSH_CMD "mv /etc/bashrc-bak /etc/bashrc;while read line;do mv /etc/profile.d/\${line}-bak /etc/profile.d/\${line};done </home/tmp" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "rm -rf /home/log /home/log1 /home/test1 /home/test2 /home/tmp" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
