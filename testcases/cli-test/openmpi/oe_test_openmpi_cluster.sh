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
#@Desc      	:   command test openmpi cluster
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "openmpi openmpi-devel"
    hostname node1
    {
        echo "${NODE1_IPV4} node1"
        echo "${NODE2_IPV4} node2"
    } >>/etc/hosts
    SSH_CMD "dnf install -y openmpi openmpi-devel;
    hostname node2;
    echo '${NODE1_IPV4} node1\n${NODE2_IPV4} node2' >> /etc/hosts
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    ping -c 3 node2
    SSH_CMD "ping -c 3 node1;rm -rf ~/.ssh/*;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    rm -rf ~/.ssh/*
    ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa
    test -f ~/.ssh/id_rsa.pub || LOG_ERROR "'~/.ssh/id_rsa.pub': No such file"
    expect -c"
        log_file testlog
        spawn ssh-copy-id -i /root/.ssh/id_rsa.pub node2
        expect {
                \"*)?\"  {
                        send \"yes\\r\"
                        exp_continue
                }
                \"*assword:*\"  {
                        send \"${NODE2_PASSWORD}\\r\"
                        exp_continue
                }
    }
    "
    mkdir -p /home/mpi_volumn
    DNF_INSTALL "nfs-utils nfs-utils-devel"
    echo "/home/mpi_volumn ${NODE1_IPV4} (rw,sync,no_root_squash,no_subtree_check,insecure)" >>/etc/exports
    systemctl start nfs
    systemctl stop firewalld
    iptable -F
    SSH_CMD "
    mkdir -p /home/mpi_volumn;
    dnf install -y nfs-utils nfs-utils-devel;
    systemctl stop firewalld;
    mount -t nfs ${NODE1_IPV4}:/home/mpi_volumn /home/mpi_volumn;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    touch /home/mpi_volumn/hello_world
    SSH_CMD "test -f /home/mpi_volumn/hello_world || exit 1;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    cp -rf ./test.c /home/mpi_volumn/
    casepath=$(cd "$(dirname $0)" || exit 1
    pwd)
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /home/mpi_volumn/ || exit 1
    /usr/lib64/openmpi/bin/mpicc test.c -o testfile
    test -f testfile
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 2 -host node1,node2 ./testfile 2>&1 | grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    printf "node1 slots=2\nnode2 slots=2" >./myhostfile
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 4 -hostfile myhostfile ./testfile 2>&1 | grep -c -e "processor node1" -e "processor node2")" -eq 4
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 2 -H node1,node2 -npersocket 1 ./testfile 2>&1 | grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 2 -H node1,node2 -npernode 1 ./testfile 2>&1 | grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 2 -H node1,node2 -pernode ./testfile 2>&1 | grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 4 --byslot --hostfile myhostfile ./testfile 2>&1 | grep -c -e "processor node1" -e "processor node2")" -eq 4
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root --mca rmaps_base_schedule_policy slot -np 4 ./testfile 2>&1 | grep -c "processor node1")" -eq 4
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 4 --bynode --hostfile myhostfile ./testfile 2>&1 | grep -c -e "processor node1" -e "processor node2")" -eq 4
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root --mca rmaps_base_schedule_policy node -np 4 ./testfile 2>&1 | grep -c "processor node1")" -eq 4
    CHECK_RESULT $?
    mkdir /tmp/bak_mpi_volumn
    cp -r /home/mpi_volumn/testfile /tmp/bak_mpi_volumn
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root --wdir /tmp/bak_mpi_volumn ./testfile 2>&1 | grep -c "processor node1")" -eq 4
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/mpirun --allow-run-as-root -d ./testfile 2>&1 |grep "MPIR_debug_state"
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -np 4 --report-bindings --map-by core --bind-to core ./testfile 2>&1 | grep -c "core")" -eq 4
    CHECK_RESULT $?
    printf "rank 0=node1 slot=1\nrank 1=node2 slot=2" > ./myrankfile
    /usr/lib64/openmpi/bin/mpirun --allow-run-as-root -H node1,node2 -rf myrankfile ./testfile 2>&1 > test.result
#    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root -H node1,node2 -rf myrankfile ./testfile 2>&1 | grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    test "$(/usr/lib64/openmpi/bin/mpirun --allow-run-as-root --prefix /usr/lib64/openmpi -H node2 ./testfile 2>&1 | grep -c "processor node2")" -eq 1
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-clean -v
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-clean -d
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-dvm --allow-run-as-root -report-uri dvm_uri > result 2>&1 &
    SLEEP_WAIT 1
    grep "${NODE1_IPV4}" dvm_uri
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-server -d > ./ompi-server.result 2>&1 &
    SLEEP_WAIT 1
    grep "up and running" ./ompi-server.result
    CHECK_RESULT $?
    /usr/lib64/openmpi/bin/ompi-server -r server_uri
    SLEEP_WAIT 1
    grep "${NODE1_IPV4}" server_uri
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -9 ompi
    cd "${casepath}" || exit 1
    hostname localhost
    rm -rf /home/mpi_volumn /etc/exports ./*log /tmp/bak_mpi_volumn
    DNF_REMOVE
    SSH_CMD "umount -f /home/mpi_volumn;
    dnf remove -y openmpi openmpi-devel nfs-utils nfs-utils-devel;
    hostname localhost;sed -i '/node/d' /etc/hosts;reboot;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" "60" &
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
