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
# @CaseName  :   oe_test_mariadb_create_view_user
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020.4.27
# @License   :   Mulan PSL v2
# @Desc      :   Create User / View User
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
source ${OET_PATH}/conf/env.conf
function config_params() {
    LOG_INFO "Start loading data!"
    sql_password=${NODE1_PASSWORD}
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    systemctl stop firewalld
    systemctl disable firewalld

    setenforce 0
    groupadd mysql
    useradd -g mysql mysql
    echo ${sql_password} | passwd --stdin mysql
    test -d /data/mariadb || mkdir -p /data/mariadb
    cd /data/mariadb || exit
    mkdir data tmp run log
    chown -R mysql:mysql /data
    cd - || exit
    rm -rf /var/lib/mysql/*
    DNF_INSTALL mariadb-server
    CHECK_RESULT $?
    systemctl start mariadb
    mysqladmin -uroot password ${sql_password}
    CHECK_RESULT $?
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    expect -c "
    set timeout 10
    log_file testlog
    spawn mysql -u root -p 
    expect {
        \"Enter*\" { send \"${sql_password}\r\";
        expect \"Maria*\" { send \"CREATE USER 'userexample1@localhost' IDENTIFIED BY '123456';\r\"}
	    expect \"Maria*\" { send \"CREATE USER 'userexample2@192.168.122.110' IDENTIFIED BY '123456';\r\"}
        expect \"Maria*\" { send \"SHOW GRANTS FOR 'userexample1@localhost';\r\"}
        expect \"Maria*\" { send \"SELECT USER,HOST,PASSWORD FROM mysql.user;\r\"}
        expect \"Maria*\" { send \"exit\r\"}
}
}
expect eof
"
    CHECK_RESULT $?
    cat testlog | grep "SHOW GRANTS FOR" -A 10 | grep "GRANT USAGE ON" | grep userexample1 | grep localhost
    CHECK_RESULT $?
    cat testlog | grep "SELECT USER" -A 10 | grep userexample1 | grep localhost
    CHECK_RESULT $?
    cat testlog | grep "SELECT USER" -A 10 | grep userexample2 | grep 192.168.122.110
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    expect -c "
    set timeout 10
    spawn mysql -u root -p 
    expect {
        \"Enter*\" { send \"${sql_password}\r\";
        expect \"Maria*\" { send \"DROP USER 'userexample1'@'localhost';\r\"}
        expect \"Maria*\" { send \"DROP USER 'userexample2'@'${NODE1_IPV4}';\r\"}
        expect \"Maria*\" { send \"exit\r\"}
}
}
expect eof
"
    setenforce 1
    DNF_REMOVE
    userdel -r mysql
    groupdel mysql
    rm -rf testlog
    LOG_INFO "Finish environment cleanup."
}

main $@
