#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   doraemon2020
#@Contact   	:   xcl_job@163.com
#@Date      	:   2020-11-20
#@License   	:   Mulan PSL v2
#@Desc      	:   command test openmpi single
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "openmpi openmpi-devel"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test "$(/usr/lib64/openmpi/bin/mpiexec --version | grep -Eo "[0-9]\.[0-9]\.[0-9]")" == "$(rpm -qa openmpi | awk -F "-" '{print$2}')"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/mpiexec --allow-run-as-root -h | grep "Usage"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/mpicc hello.c -o hello
    test -f hello
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/mpiexec --allow-run-as-root -np 4 ./hello
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --version | grep -Eo "[0-9]\.[0-9]\.[0-9]")" == "$(rpm -qa openmpi | awk -F "-" '{print$2}')"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/mpirun --allow-run-as-root -h | grep "Usage"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 4 ./hello
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-clean -h | grep "ompi-clean \[OPTIONS\]"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-dvm --allow-run-as-root -h | grep "Usage"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-dvm --allow-run-as-root -V | grep -E "ompi-dvm.*[0-9].[0-9].[0-9]"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-ps -h | grep "ompi-ps \[OPTIONS\]"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-server -h | grep "Usage"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-submit --allow-run-as-root -h | grep "Usage"
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/ompi-submit --allow-run-as-root -V | grep -Eo "[0-9]\.[0-9]\.[0-9]")" == "$(rpm -qa openmpi | awk -F "-" '{print$2}')"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-top -h | grep "Usage"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi_info -h | grep "Syntax"
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/ompi_info -V | grep -Eo "[0-9]\.[0-9]\.[0-9]")" == "$(rpm -qa openmpi | awk -F "-" '{print$2}')"
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi_info
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./hello
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

