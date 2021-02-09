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
# @CaseName  :   oe_test_dnf_create_local_repository
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   Create a local software source repository
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
	LOG_INFO "Start executing testcase."
	DNF_INSTALL createrepo
	test -f /root/tmp || mkdir -p /root/tmp
	LOG_INFO "End of testcase execution."
}

function run_test() {
	LOG_INFO "Start executing testcase."
	mount /home/openEuler-20.03-LTS-SP1-aarch64-dvd.iso /home/iso
	CHECK_RESULT $?
	mkdir -p /srv/repo/
	cp -r /home/iso/Packages /srv/repo/
	CHECK_RESULT $?
	createrepo --database /srv/repo/
	CHECK_RESULT $?
	find /srv/repo/repodata > /dev/null
	CHECK_RESULT $?
	LOG_INFO "End of testcase execution."
}

function post_test() {
	LOG_INFO "start environment cleanup."
	umount /home/iso
	rm -rf /srv/repo/*
	DNF_REMOVE
	LOG_INFO "Finish environment cleanup."
}

main $@
