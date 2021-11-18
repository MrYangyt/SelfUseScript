#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
'''
@File    :   curlIpToWeixin.py
@Time    :   2021/11/18 13:39:03
@Author  :   MrYangyt 
@Version :   1.0
@Contact :   944960511@qq.com
@License :   (C)Copyright 2021-2099, Liugroup-NLPR-CASIA
@Desc    :   None
'''
# here put the import lib



import requests
import re
import json
from apscheduler.schedulers.blocking import BlockingScheduler
##查询本地外网ip
r = requests.get("http://txt.go.sohu.com/ip/soip")
ip = re.findall(r'\d+.\d+.\d+.\d+',r.text)
#print(ip[0])
ip_i = (ip[0])
corpid = "#####################################"
corpsecret = "###########################################"
def weixin():
    access_token = requests.get("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid={}&corpsecret={}".format(corpid,corpsecret))
    access_token_a = json.loads(access_token.text)
    access_token_r = (access_token_a['access_token'])
    #print (access_token_r)
    data = {
    "touser" : "YangYiTao",
    "msgtype" : "text",
    "agentid" : 1000002,
    "text" : {
        "content" : "你的ip:{}".format(ip_i)
    },
    "safe":0,
    "enable_id_trans": 0,
    "enable_duplicate_check": 0,
    "duplicate_check_interval": 1800
    }
    headers = {'Content-Type': 'application/json'}
    url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token={}".format(access_token_r)
    response = requests.post(url, headers=headers, data=json.dumps(data))
    
def dojob():
    #创建调度器：BlockingScheduler
    scheduler = BlockingScheduler()
    #添加任务,时间间隔2S
    scheduler.add_job(weixin, 'interval', seconds=2, id='test_job1')
    scheduler.start()
weixin()