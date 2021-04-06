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
# @CaseName  :   oe_test_mariadb_backup_restore_db
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020.4.27
# @License   :   Mulan PSL v2
# @Desc      :   POSTGRESQL create run delete
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

    test -d /data/mariadb || mkdir /data/mariadb
    CHECK_RESULT $?
    cd /data/mariadb || exit
    mkdir data tmp run log
    chown -R mysql:mysql /data
    cd - || exit
    DNF_INSTALL mariadb-server
    CHECK_RESULT $?
    rm -rf /var/lib/mysql/*
    systemctl start mariadb
    CHECK_RESULT $?
    mysqladmin -uroot password ${sql_password}
    expect -c "
    set timeout 10
    log_file testlog
    spawn mysql -u root -p 
    expect {
        \"Enter*\" { send \"${sql_password}\r\";
        expect \"Maria*\" { send \"CREATE DATABASE db1;\r\"}
        expect \"Maria*\" { send \"CREATE DATABASE db2;\r\"}
        expect \"Maria*\" { send \"use db1;\r\"}
	    expect \"Maria*\" { send \"create table tb1(id int(3), name char(8));\r\"}
        expect \"Maria*\" { send \"CREATE DATABASE db3;\r\"}
        expect \"Maria*\" { send \"use db3;\r\"}
	    expect \"Maria*\" { send \"create table tb1(id int(3), name char(8));\r\"}
        expect \"Maria*\" { send \"SHOW DATABASES;\r\"}
        expect \"Maria*\" { send \"exit\r\"}
}
}
expect eof
"
    cat testlog | grep '\|' | grep "Database" -A 5 | grep -cwE 'db1|db2|db3'
    rm -rf testlog
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    expect -c "
    set timeout 10
    spawn mysql -u root -p 
    expect {
        \"Enter*\" { send \"${sql_password}\r\";
        expect \"Maria*\" { send \"grant all privileges on *.* to 'root'@'$NODE1_IPV4' IDENTIFIED BY '$NODE1_PASSWORD' WITH GRANT OPTION;\r\"}
        expect \"Maria*\" { send \"flush privileges;\r\"}
        expect \"Maria*\" { send \"exit\r\"}
}
}
expect eof
"
    CHECK_RESULT $?
    mysqldump -h ${NODE1_IPV4} -P 3306 -uroot -p${NODE1_PASSWORD} --all-databases >alldb.sql
    CHECK_RESULT $?
    find alldb.sql
    CHECK_RESULT $?

    mysqldump -h ${NODE1_IPV4} -P 3306 -uroot -p${NODE1_PASSWORD} --databases db1 >db1.sql
    CHECK_RESULT $?
    find db1.sql
    CHECK_RESULT $?

    mysqldump -h ${NODE1_IPV4} -P 3306 -uroot -p${NODE1_PASSWORD} db1 tb1 >db1tb1.sql
    CHECK_RESULT $?
    find db1tb1.sql
    CHECK_RESULT $?

    rm -rf db1.sql
    mysqldump -h ${NODE1_IPV4} -P 3306 -uroot -p${NODE1_PASSWORD} -d db1 >db1.sql
    CHECK_RESULT $?
    find db1.sql
    CHECK_RESULT $?

    rm -rf db1.sql
    mysqldump -h ${NODE1_IPV4} -P 3306 -uroot -p${NODE1_PASSWORD} -t db1 >db1.sql
    CHECK_RESULT $?
    find db1.sql
    CHECK_RESULT $?

    mysql -h ${NODE1_IPV4} -P 3306 -uroot -p${NODE1_PASSWORD} -t db3 <db1.sql
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
        expect \"Maria*\" { send \"DROP DATABASE db1;\r\"}
        expect \"Maria*\" { send \"DROP DATABASE db2;\r\"}
        expect \"Maria*\" { send \"exit\r\"}
}
}
expect eof
"
    setenforce 1
    DNF_REMOVE
    userdel -r mysql
    groupdel mysql
    rm -rf db1.sql db1tb1.sql alldb.sql
    LOG_INFO "Finish environment cleanup."
}

main $@
