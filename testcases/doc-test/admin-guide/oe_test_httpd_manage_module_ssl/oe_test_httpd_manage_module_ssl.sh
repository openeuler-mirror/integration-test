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
# @CaseName  :   oe_test_httpd_manage_module_ssl
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   Management module and ssl
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
	LOG_INFO "Start environment preparation."
	DNF_INSTALL "httpd"
	LOG_INFO "Environmental preparation is over."
}

function run_test() {
	LOG_INFO "Start executing testcase."
	systemctl enable httpd
	systemctl start httpd
	sed -i "s/#LoadModule asis_module modules\/mod_asis.so/LoadModule asis_module modules\/mod_asis.so/g" /etc/httpd/conf.modules.d/00-optional.conf
	systemctl restart httpd
	CHECK_RESULT $?
	httpd -M | grep asis
	CHECK_RESULT $?
	DNF_INSTALL mod_ssl
	systemctl restart httpd
	CHECK_RESULT $?
	httpd -M | grep ssl
	CHECK_RESULT $?
	LOG_INFO "End of testcase execution."
}

function post_test() {
	LOG_INFO "start environment cleanup."
	sed -i "s/#LoadModule asis_module modules\/mod_asis.so/LoadModule asis_module modules\/mod_asis.so/g" /etc/httpd/conf.modules.d/00-optional.conf
	DNF_REMOVE
	LOG_INFO "Finish environment cleanup."
}

main $@
