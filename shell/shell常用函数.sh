#!/bin/bash
# -*- encoding: utf-8 -*-
'''
@File    :   shell常用函数.sh
@Time    :   2021/11/16 16:42:43
@Author  :   MrYangyt 
@Version :   1.0
@Contact :   944960511@qq.com
@License :   (C)Copyright 2021-2099, Liugroup-NLPR-CASIA
@Desc    :   None
'''
# here put the import lib

#向下取整数函数
function ceil(){
  floor=`echo "scale=0;$1/1"|bc -l ` # 向下取整
  add=`awk -v num1=$floor -v num2=$1 'BEGIN{print(num1<num2)?"1":"0"}'`
  echo `expr $floor  + $add`
}
# ceil 3.333