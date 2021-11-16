#!/bin/bash
# -*- encoding: utf-8 -*-
'''
@File    :   robot-sql-dingding.sh
@Time    :   2021/11/16 16:44:36
@Author  :   MrYangyt 
@Version :   1.0
@Contact :   944960511@qq.com
@License :   (C)Copyright 2021-2099, Liugroup-NLPR-CASIA
@Desc    :   None
'''
# here put the import lib


DING_ROBOT_URL="https://oapi.dingtalk.com/robot/send?access_token=###################################"

MYSQL_HOST=##########
MYSQL_PORT=3411
MYSQL_USER=user
MYSQL_PW=j_73dCxIeECrtUKs

##执行sql的函数
function exec_mysql() {
    local sql="$*"
    printf "%s" "exec mysql: $sql ... " >&2
    if mysql --default-character-set=utf8 -sN -u $MYSQL_USER -P$MYSQL_PORT -h $MYSQL_HOST -p$MYSQL_PW -e "$sql"; then
        echo "sql executed: ok"
    else
        echo "sql executed: failed"
    fi
}
##取数据库数据的函数
user_attrs=""
columnNum=8
#通过参数行数和行索引位置
function getValue() {
    #调用方法传入的第一个参数，$0 表示方法名
    colIndex=$1
    #调用方法传入的第二个参数
    rowIndex=$2
    #定位到指定行，数组索引0为第一个元素
    #数学算术运算使用 $((a+b))
    idx=$(($columnNum * $rowIndex + $colIndex - 1))
    #判读索引值是否大于结果行数
    #${#arrays_name[@]}获取数组长度
    if [ $idx -le ${#user_attrs[@]} ]; then
        echo ${user_attrs[$idx]}
    fi
}

function getRowNum() {
    echo $((${#user_attrs[@]} / $columnNum - 1))
}

##sql语句

SQL_PASS_RATE=""
##执行sql语句
user_attrs=($(mysql --default-character-set=utf8 -sN -u $MYSQL_USER -P$MYSQL_PORT -h $MYSQL_HOST -p$MYSQL_PW -e "$SQL_PASS_RATE"))
##取值
dealdate=$(getValue 1 0)
passQiao=$(getValue 2 0)
passZhi=$(getValue 3 0)
passRZhi=$(getValue 4 0)
numOfConfirm=$(getValue 5 0)
amount=$(getValue 6 0)
passRQiao=$(getValue 7 0)
passR=$(getValue 8 0)


if [ -n "$reason" ]; then

MSG_TEXT="监控信息

$reason

@ $dealdate
---
智度：
当日Tars通过: $passQiao      
当日智度通过: $passZhi        智度通过率: $passRZhi
当日确认: $numOfConfirm      确认金额: $amount
---

"

else

MSG_TEXT="监控信息

@ $dealdate
---
智度：
当日Tars通过: $passQiao      
当日智度通过: $passZhi        智度通过率: $passRZhi
当日确认: $numOfConfirm      确认金额: $amount
---

"

fi

# echo $MSG_TEXT

##发送dingding
curl $DING_ROBOT_URL \
    -H 'Content-Type: application/json' \
    -d "
{\"msgtype\": \"text\", 
\"text\": {
    \"content\": \"$MSG_TEXT\"
    }
}"


