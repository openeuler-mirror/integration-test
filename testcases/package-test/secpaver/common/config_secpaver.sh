#!/bin/bash
source "$OET_PATH/libs/locallibs/common_lib.sh"
project_name=proj"$RANDOM"

#################################################################
## @Description 导入工程文件
function project_import() {
    ps -ef | grep pavd
    pav project create "$project_name" . || exit 1
    zip -r "$project_name".zip "$project_name"/ || exit 1
    pav project import "$project_name".zip || exit 1
}

#################################################################
## @Description 导入并编译工程，参数为工程zip压缩文件
#################################################################
function import_build_project() {
    pav project list | grep "$1"
    res=$?
    if [ "$res" -ne 0 ]; then
        pav project import ../common/"$1".zip
        CHECK_RESULT "$?" 0 0 "Error: $1.zip not found"
    fi
    pav project build -r "$1" --engine selinux
    CHECK_RESULT "$?" 0 0 "Error: compile $1 failed"
}

#################################################################
## @Description 部署策略，参数为策略zip压缩文件
#################################################################
function install_strategy() {
    setenforce 0
    pav policy list | grep "$1"
    CHECK_RESULT "$?" 0 0 "Error: $1 project not imported or compiled"
    if [$(pav policy list | grep "$1") -eq 1]; then
        pav policy install "$1"_selinux
    else
        pav policy list | grep "\"$1\"_public" | awk '{print $1}' | xargs pav policy install
        pav policy list | grep "$1" | grep -v "\"$1\"_public" | awk '{print $1}' | xargs -L 1 pav policy install
    fi
    CHECK_RESULT $? 0 0 "Error: $1 selinux policy install failed"
    setenforce 1
}

#################################################################
## @Description 卸载策略，参数为策略zip压缩文件
#################################################################
function uninstall_strategy() {
    setenforce 0
    pav policy list | grep "$1"_selinux
    CHECK_RESULT $? 0 0 "Error: $1 selinux policy not installed"
    if [$(pav policy list | grep "$1") -eq 1]; then
        pav policy uninstall "$1"_selinux
    else
        pav policy list | grep "\"$1\"_public" | awk '{print $1}' | xargs pav policy uninstall
        pav policy list | grep "$1" | grep -v "\"$1\"_public" | awk '{print $1}' | xargs -L 1 pav policy uninstall
    fi
    CHECK_RESULT $? 0 0 "Error: $1 selinux policy uninstall failed"
    setenforce 1
}

#################################################################
## @Description 创建验证文件标签需要的测试资源文件
#################################################################
function create_file_lable_test_resource() {
    cur_dir=$(pwd)
    cd /tmp/ || exit 1
    if [ ! -d fileresource ]; then
        mkdir fileresource
        cd fileresource/ || exit 1
        for ((i = 1; i < 10; i++)); do
            if [ ! -f secpaverFile"$i" ]; then
                touch secpaverFile"$i"
                echo "secpaverFile${i}" >> secpaverFile"$i"
            fi
        done
    fi
    cd "$cur_dir" || exit 1
}

#################################################################
## @Param $1:resource file name
## @Usage secpaver network rules, secpaver selinux file rule
## @Return
## @Description 在安全策略部署之前，创建被测资源文件
#################################################################
function resource_create() {
    mkdir /resource/
    touch /resource/file
    touch /resource/file4
    chmod u+x "$1"
    cp -r "$1" /bin/
}

#################################################################
## @Param $1:resource file name
## @Usage secpaver network rules, secpaver selinux file rule
## @Return
## @Description 卸载策略之后，删除被测资源文件
#################################################################
function resource_clear() {
    rm -rf /resource
    rm -rf /bin/"${1:?}"
}

#################################################################
## @Usage secpaver network rules, secpaver selinux file rule
## @Return
## @Description 卸载网络策略之后，删除临时文件和残留socket文件
#################################################################
function socket_file_clear() {
    rm -rf /home/secpaver_hostmsg
    rm -rf /var/run/test.sock
}
