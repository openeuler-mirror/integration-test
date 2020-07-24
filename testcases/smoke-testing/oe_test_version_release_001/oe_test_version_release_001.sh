#!/usr/bin/bash
# #############################################
# @Author    :   yuanlulu
# @Contact   :   @163.com
# @Date      :   2020-07-23
# @License   :   Mulan PSL v2?
# @Desc      :   File system common command test-version
# ############################################


set +o posix
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function run_test() {
    LOG_INFO "Start testing..."
    #将未安装的包做备份
    yum list available >available
    #去除前两行
    sed -i '1,2d' available

    #将未安装的包名放在remove_ope数组中
    remove_ope=(`awk '{print $1}' available`)
    failed_list=""

    for rpm in ${remove_ope[@]}
    do
        yum -y install $rpm  
        version=$(rpm -qi ${rpm} | grep Version | awk '{print $NF}')
        release=$(rpm -qi ${rpm} | grep Release | awk '{print $NF}')
        rpm -qi ${rpm} | grep "Source RPM" | grep -w "${version}-${release}" || failed_list="${failed_list} ${rpm}"
    done
    [ -z "$failed_list" ]
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment reset."
    for item in ${remove_ope[@]}
    do
       #把未安装的包删除
       yum -y remove $item --noautoremove
    done
    echo ${failed_list}
    LOG_INFO "Finish environment reset!"
}

main $@

