#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   polite2anyone
#@Contact   	:   zhangyao05@outlook.com
#@Date      	:   2021-06-16
#@License   	:   Mulan PSL v2
#@Desc      	:   command test openhpid
#####################################

#Usage:
#  openhpid [OPTION?] - HPI instance to which multiple clients can connect.

#A typical invocation might be
#  ./openhpid -c /etc/openhpi/openhpi.conf

#Command openhpid [options] ...
#Help Options:
#  -h, --help                  Show help options

#Application Options:
#  -c, --cfg=conf_file         Sets path/name of the configuration file.
#                            This option is required unless the environment
#                            variable OPENHPI_CONF has been set to a valid
#                            configuration file.
#  -v, --verbose               This option causes the daemon to display verbose
#                            messages. This option is optional.
#  -b, --bind=bind_address     Bind address for the daemon socket.
#                            Also bind address can be specified with
#                            OPENHPI_DAEMON_BIND_ADDRESS environment variable.
#                            No bind address is used by default.
#  -p, --port=port             Overrides the default listening port (4743) of
#                            the daemon. The option is optional.
#  -f, --pidfile=pidfile       Overrides the default path/name for the daemon.
#                            pid file. The option is optional.
#  -s, --timeout=seconds       Overrides the default socket read timeout of 30
#                            minutes. The option is optional.
#  -t, --threads=threads       Sets the maximum number of connection threads.
#                            The default is umlimited. The option is optional.
#  -n, --nondaemon             Forces the code to run as a foreground process
#                            and NOT as a daemon. The default is to run as
#                            a daemon. The option is optional.
#  -d, --decrypt               Config file encrypted with hpicrypt. Decrypt and read
#  -6, --ipv6                  The daemon will try to bind IPv6 socket.
#  -4, --ipv4                  The daemon will try to bind IPv4 socket (default).
#                            IPv6 option takes precedence over IPv4 option.

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "openhpi lsof"
    hpi_path=$(whereis openhpi | awk '{print$3}')
    {
        export "HPI_PATH=${hpi_path}"
    }
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    openhpid -? 2>&1 | grep "Options"
    CHECK_RESULT $?
    openhpid -c $HPI_PATH/openhpi.conf
    CHECK_RESULT $?
    lsof -i:4743 | grep "openhpid"
    CHECK_RESULT $?
    pkill -9 openhpid

    openhpid -c $HPI_PATH/openhpi.conf -p 1111
    CHECK_RESULT $?
    lsof -i:1111 | grep "openhpid"
    CHECK_RESULT $?
    pkill -9 openhpid

    openhpid -c $HPI_PATH/openhpi.conf -p 1111 -s 30 -t 10
    CHECK_RESULT $?
    lsof -i:1111 | grep "openhpid"
    CHECK_RESULT $?
    ps -ef | grep "-s 30 -t 10"
    CHECK_RESULT $?
    pkill -9 openhpid

    openhpid -c $HPI_PATH/openhpi.conf -4
    CHECK_RESULT $?
    lsof -i:4743 | grep "IPv4"
    CHECK_RESULT $?
    pkill -9 openhpid

    openhpid -c $HPI_PATH/openhpi.conf -6
    CHECK_RESULT $?
    lsof -i:4743 | grep "IPv6"
    CHECK_RESULT $?
    pkill -9 openhpid
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -9 openhpid
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
