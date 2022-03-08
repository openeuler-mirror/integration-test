#!/usr/bin/bash

#@ License : Mulan PSL v2
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   zengxianjun
# @Contact   :   mistachio@163.com
# @Date      :   2022/03/02
# @Desc      :   /usr/bin/pav, /usr/bin/pavd authourity test
# ##################################

source ../common/config_secpaver.sh
set +e

function pre_test() {
    # Install pavd
    DNF_INSTALL secpaver && systemctl start pavd
}

function run_test() {
    # check pav file mode
    mode=$(stat -c %a /bin/pav)
    user=$(stat -c %U /bin/pav)
    CHECK_RESULT "$mode" 700 0 "invalid mode of pav file."
    CHECK_RESULT "$user" "root" 0 "invalid owner of pav file."

    # check pavd file mode
    mode=$(stat -c %a /bin/pavd)
    user=$(stat -c %U /bin/pavd)
    CHECK_RESULT "$mode" 700 0 "invalid mode of pavd file."
    CHECK_RESULT "$user" "root" 0 "invalid owner of pavd file."
}

function post_test() {
    return
}

main "$@"
