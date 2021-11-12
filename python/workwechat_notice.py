#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
'''
@File    :   workwechat_notice.py
@Time    :   2021/11/12 17:29:49
@Author  :   MrYangyt 
@Version :   1.0
@Contact :   944960511@qq.com
@License :   (C)Copyright 2021-2099, Liugroup-NLPR-CASIA
@Desc    :   None
'''
# here put the import lib
#定时给女朋友发送天气消息
import requests
import re
import json
from bs4 import BeautifulSoup
from apscheduler.schedulers.blocking import BlockingScheduler
import time
#填写自己的企微信息
corpid = "#############"
corpsecret = "###########"
def weixin():
    access_token = requests.get("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid={}&corpsecret={}".format(corpid,corpsecret))
    access_token_a = json.loads(access_token.text)
    access_token_r = (access_token_a['access_token'])
    try:
        #print(city_code)
        url = 'http://www.weather.com.cn/weather/101290101.shtml'
        ret = requests.get(url)
    except BaseException as e:
        print('e')
        return {}

    ret.encoding = 'utf-8'
    soup = BeautifulSoup(ret.text, 'html.parser')
    tagToday = soup.find('p', class_ = "tem")  #第一个包含class="tem"的p标签即为存放今天天气数据的标签
    try:
        temperatureHigh = tagToday.span.string  #有时候这个最高温度是不显示的，此时利用第二天的最高温度代替。
    except AttributeError:
        temperatureHigh = tagToday.find_next('p', class_="tem").span.string  #获取第二天的最高温度代替

    temperatureLow = tagToday.i.string  #获取最低温度
    weather = soup.find('p', class_ = "wea").string #获取天气
    wind = soup.find('p', class_ = "win") #获取风力
    clothes = soup.find('li', class_ = "li3 hot") #穿衣指数
    time_today= time.strftime("%Y-%m-%d", time.localtime())
    #print ('臭宝，昆明今天天气如下：')
    #print ('当前日期：{}'.format(time_today))
    #print('最低温度:' + temperatureLow)
    #print('最高温度:' + temperatureHigh)
    #print('天气:' + weather)
    #print('c:' + wind.i.string)
    #print('穿衣:' + clothes.a.span.string + "," + clothes.a.p.string)
    #print (access_token_r)
    data = {
    #添加需要发送的企业微信id
    "touser" : "YangYiTao|YiLianLengMo",
    "msgtype" : "text",
    "agentid" : 1000002,
    "text" : {
        #拼接字符串
        "content" : '臭宝，昆明今天天气如下：\n' + '当前日期：' + time_today + '\n' + '最低温度: ' + temperatureLow + '\n' + '最高温度: ' + temperatureHigh + '\n' + '天气: ' + weather + '\n' + '风力: ' + wind.i.string + '\n' + '穿衣: ' + clothes.a.span.string + "," + clothes.a.p.string
    },
    "safe":0,
    "enable_id_trans": 0,
    "enable_duplicate_check": 0,
    "duplicate_check_interval": 1800
    }
    headers = {'Content-Type': 'application/json'}
    url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token={}".format(access_token_r)
    response = requests.post(url, headers=headers, data=json.dumps(data))
    
def dojob(): #创建定时器，定时执行
    #创建调度器：BlockingScheduler
    scheduler = BlockingScheduler()
    #添加任务,时间间隔2S
    scheduler.add_job(weixin, 'cron',  hour='7', minute='01', id='test_job1')
    scheduler.start()
#weixin()
dojob()