#!/bin/bash
# -*- encoding: utf-8 -*-
'''
@File    :   log_back.sh
@Time    :   2021/11/12 17:51:44
@Author  :   MrYangyt 
@Version :   1.0
@Contact :   944960511@qq.com
@License :   (C)Copyright 2021-2099, Liugroup-NLPR-CASIA
@Desc    :   None
'''
# here put the import lib

time=`date +%Y-%m-%d -d  '-1 Day'`  ##前一日按日期
#日志文件及目录
dir_list=`find /data1/logs/ -type d -name "*com"`

if [[ ! -n "$dir_list" ]];
then
        exit 0
else

    for k in $dir_list;
    do
        cd ${k}
        log_list=`ls|grep ${time}`    ##日志名空格拼接大集合

        if [[ ! -n "$log_list" ]];        ##判断集合是否为空，遇到极端情况一天没有日志文件产生，匹配的日志文件变量为空
        then
                continue
        else
            for k in $log_list;      ##取出完整日志文件名赋值为k
            do
                        tar zcf ${k}.tar.gz ${k}
                        \rm -rf ${k}
            done
        fi
        find . -type f -mtime +60 -exec \rm -f {} \;
    done
fi
