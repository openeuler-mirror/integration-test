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
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/5/14
# @License   :   Mulan PSL v2
# @Desc      :   Public class, environment construction
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_junit5() {
    DNF_INSTALL junit5
    java_version=$(rpm -qa 'java*' | grep 'java-.*-openjdk' | awk -F - '{print $2}')
    DNF_INSTALL java-"${java_version}"-devel
    wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.2/junit-platform-console-standalone-1.6.2.jar
}

function pre_maven() {
    DNF_INSTALL maven
    cp /etc/profile /etc/profile-bak
    JAVA_HOME=/usr/lib/jvm/java-openjdk
    PATH=$PATH:$JAVA_HOME/bin
    export JAVA_HOME PATH
    export MAVEN_HOME=/usr/share/maven
    export PATH=$PATH:$MAVEN_HOME
}

function clean_junit5() {
    DNF_REMOVE
    rm -rf junit-platform-console-standalone-1.6.2.jar
}

function clean_maven() {
    DNF_REMOVE
    mv /etc/profile-bak /etc/profile -f
    source /etc/profile >/dev/null
}
