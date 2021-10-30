#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   polite2anyone
#@Contact   	:   zhangyao05@outlook.com
#@Date      	:   2021-07-28
#@License   	:   Mulan PSL v2
#@Desc      	:   command test openhpid
#####################################


#Usage: pbzip2 [-1 .. -9] [-b#cdfhklm#p#qrS#tVz] <filename> <filename2> <filenameN>
# -1 .. -9        set BWT block size to 100k .. 900k (default 900k)
# -b#             Block size in 100k steps (default 9 = 900k)
# -c,--stdout     Output to standard out (stdout)
# -d,--decompress Decompress file
# -f,--force      Overwrite existing output file
# -h,--help       Print this help message
# -k,--keep       Keep input file, don't delete
# -l,--loadavg    Load average determines max number processors to use
# -m#             Maximum memory usage in 1MB steps (default 100 = 100MB)
# -p#             Number of processors to use (default: autodetect [1])
# -q,--quiet      Quiet mode (default)
# -r,--read       Read entire input file into RAM and split between processors
# -S#             Child thread stack size in 1KB steps (default stack size if unspecified)
# -t,--test       Test compressed file integrity
# -v,--verbose    Verbose mode
# -V,--version    Display version info for pbzip2 then exit
# -z,--compress   Compress file (default)
# --ignore-trailing-garbage=# Ignore trailing garbage flag (1 - ignored; 0 - forbidden)



source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "tar pbzip2"
    cp -r ../common/testfile.txt ./
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pbzip2 -h 2>&1 | grep "USAGE:"
    CHECK_RESULT $?

    pbzip2 -V 2>&1 | grep "BZIP2 v*"
    CHECK_RESULT $?

    #set block size = 200KB
    pbzip2 -v -2 testfile.txt 2>&1 | grep "BWT BLOCK Size: 200 KB"
    CHECK_RESULT $?
    pbzip2 -d testfile.txt.bz2
    CHECK_RESULT $?

    #set processors = 2
    pbzip2 -v -p2 testfile.txt 2>&1 | grep "# CPUs: 2"
    CHECK_RESULT $?
    pbzip2 -d testfile.txt.bz2
    CHECK_RESULT $?

    #set maxium memory size = 2M
    pbzip2 -v -m2 testfile.txt 2>&1 | grep "Maximum Memory: 2 MB"
    CHECK_RESULT $?
    pbzip2 -d testfile.txt.bz2
    CHECK_RESULT $?

    #keep source file after compressed
    pbzip2 -k testfile.txt
    test -f testfile.txt
    CHECK_RESULT $?
    pbzip2 -d testfile.txt.bz2
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf testfile*
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
