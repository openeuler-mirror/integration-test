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
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2020/10/10
# @License   :   Mulan PSL v2
# @Desc      :   Public class, environment construction
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function postgresql_install() {
    DNF_INSTALL "postgresql postgresql-server postgresql-devel postgresql-contrib"
    /usr/bin/postgresql-setup --initdb
    sed -i 's/ident/trust/g' /var/lib/pgsql/data/pg_hba.conf
    systemctl start postgresql
    expect <<-END
    spawn su - postgres
    expect "postgres"
    send "createdb testdb\n"
    expect "postgres"
    send "psql testdb\n"
    expect "postgres"
    send "create table test (id int, val numeric);\n"
    expect "CREATE TABLE"
    send "create index on test(id);\n"
    expect "CREATE INDEX"
    send "create index on test(val);\n"
    expect "CREATE INDEX"
    send "insert into test select generate_series(1,10000),random();\n"
    expect "INSERT 0 10000"
    send "create table tab_big(vname text,souroid oid);\n"
    expect "CREATE TABLE"
    send "insert into tab_big values('passwd list',lo_import('/etc/passwd'));\n"
    expect "INSERT 0 1"
    send "CREATE SCHEMA myschema;\n"
    expect "CREATE SCHEMA"
    send "create table myschema.test (id int, val numeric) with oids;\n"
    expect "CREATE TABLE"
    send "insert into myschema.test select generate_series(1,100),random();\n"
    expect "INSERT 0 100"
    send "create user testuder;\n"
    expect "CREATE ROLE"
    send "GRANT ALL ON test TO testuder;\n"
    expect "GRANT"
    send "\\\q\n"
    expect eof
END
}

function cluster_env() {
    firewall-cmd --add-service=postgresql --permanent
    firewall-cmd --reload
    SSH_CMD "
    firewall-cmd --add-service=postgresql --permanent
    firewall-cmd --reload
    dnf -y install postgresql postgresql-server postgresql-devel postgresql-contrib
    " ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    echo -e "host\treplication\tpostgres\t${NODE2_IPV4}/32\ttrust" >>/var/lib/pgsql/data/pg_hba.conf
    cat >>/var/lib/pgsql/data/postgresql.conf <<EOF
    listen_addresses = '${NODE1_IPV4}'
    wal_level = hot_standby
    max_connections = 1000
    hot_standby = on 
    max_standby_streaming_delay = 30s
    wal_receiver_status_interval = 10s  
    hot_standby_feedback = on
    wal_log_hints = on
EOF
    systemctl restart postgresql
    cat >temp.file <<EOF
    standby_mode = on
    primary_conninfo = 'host=${NODE1_IPV4} port=5432 user=postgres password=postgres'
    recovery_target_timeline = 'latest'
EOF
    SSH_SCP temp.file ${NODE2_USER}@${NODE2_IPV4}:temp.file ${NODE2_PASSWORD}
    SSH_CMD "
        rm -rf /var/lib/pgsql/data/
        pg_basebackup -h ${NODE1_IPV4} -U postgres -v -Fp -Xs -D /var/lib/pgsql/data/
        cp /usr/share/pgsql/recovery.conf.sample /var/lib/pgsql/data/recovery.conf
        chown -R postgres:postgres /var/lib/pgsql/data/
        sed -i 's/${NODE2_IPV4}/${NODE1_IPV4}/g' /var/lib/pgsql/data/pg_hba.conf
        sed -i 's/${NODE1_IPV4}/${NODE2_IPV4}/g' /var/lib/pgsql/data/postgresql.conf
        cat temp.file >> /var/lib/pgsql/data/recovery.conf
        rm -rf temp.file
        systemctl restart postgresql
        " ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    rm -rf temp.file
}
