#!/bin/bash
# -*- encoding: utf-8 -*-
'''
@File    :   cenos7_optimization.sh
@Time    :   2021/11/19 18:03:45
@Author  :   MrYangyt 
@Version :   1.0
@Contact :   944960511@qq.com
@License :   (C)Copyright 2021-2099, Liugroup-NLPR-CASIA
@Desc    :   None
'''
# here put the import lib

yum install wget telnet vim lrzsz -y
#Yum源更换为国内阿里源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
#yum重新建立缓存
yum clean all
yum makecache
#同步时间
yum -y install ntp
/usr/sbin/ntpdate cn.pool.ntp.org
echo "* 4 * * * /usr/sbin/ntpdate cn.pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root
systemctl  restart crond.service
# set timezone
test -f /etc/localtime && rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#vim优化
cat >> /root/.vimrc << EOF
set tabstop=4
set shiftwidth=4
set expandtab
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
syntax on
set number
EOF
#修改字符集
sed -i 's/LANG="en_US.UTF-8"/LANG="zh_CN.UTF-8"/' /etc/locale.conf
#优化系统参数
sed -i '$a\#关闭IPV6/g' /etc/sysctl.conf
sed -i '$a\net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf
sed -i '$a\# 避免放大攻击' /etc/sysctl.conf
sed -i '$a\net.ipv4.icmp_echo_ignore_broadcasts = 1' /etc/sysctl.conf
sed -i '$a\# 开启恶意icmp错误消息保护' /etc/sysctl.conf
sed -i '$a\net.ipv4.icmp_ignore_bogus_error_responses = 1' /etc/sysctl.conf
sed -i '$a\#关闭路由转发/g' /etc/sysctl.conf
sed -i '$a\net.ipv4.ip_forward = 0' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.all.send_redirects = 0' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.default.send_redirects = 0' /etc/sysctl.conf
sed -i '$a\#开启反向路径过滤' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.all.rp_filter = 1' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.default.rp_filter = 1' /etc/sysctl.conf
sed -i '$a\#处理无源路由的包' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.all.accept_source_route = 0' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.default.accept_source_route = 0' /etc/sysctl.conf
sed -i '$a\#关闭sysrq功能' /etc/sysctl.conf
sed -i '$a\kernel.sysrq = 0' /etc/sysctl.conf
sed -i '$a\#core文件名中添加pid作为扩展名' /etc/sysctl.conf
sed -i '$a\kernel.core_uses_pid = 1' /etc/sysctl.conf
sed -i '$a\# 开启SYN洪水攻击保护' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_syncookies = 1' /etc/sysctl.conf
sed -i '$a\#修改消息队列长度' /etc/sysctl.conf
sed -i '$a\kernel.msgmnb = 65536' /etc/sysctl.conf
sed -i '$a\kernel.msgmax = 65536' /etc/sysctl.conf
sed -i '$a\#设置最大内存共享段大小bytes' /etc/sysctl.conf
sed -i '$a\kernel.shmmax = 68719476736' /etc/sysctl.conf
sed -i '$a\kernel.shmall = 4294967296' /etc/sysctl.conf
sed -i '$a\#timewait的数量，默认180000' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_max_tw_buckets = 6000' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_sack = 1' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_window_scaling = 1' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_rmem = 4096        87380   4194304' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_wmem = 4096        16384   4194304' /etc/sysctl.conf
sed -i '$a\net.core.wmem_default = 8388608' /etc/sysctl.conf
sed -i '$a\net.core.rmem_default = 8388608' /etc/sysctl.conf
sed -i '$a\net.core.rmem_max = 16777216' /etc/sysctl.conf
sed -i '$a\net.core.wmem_max = 16777216' /etc/sysctl.conf
sed -i '$a\#每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目' /etc/sysctl.conf
sed -i '$a\net.core.netdev_max_backlog = 262144' /etc/sysctl.conf
sed -i '$a\#限制仅仅是为了防止简单的DoS 攻击' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_max_orphans = 3276800' /etc/sysctl.conf
sed -i '$a\#未收到客户端确认信息的连接请求的最大值' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_max_syn_backlog = 262144' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_timestamps = 0' /etc/sysctl.conf
sed -i '$a\#内核放弃建立连接之前发送SYNACK 包的数量' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_synack_retries = 1' /etc/sysctl.conf
sed -i '$a\#内核放弃建立连接之前发送SYN 包的数量' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_syn_retries = 1' /etc/sysctl.conf
sed -i '$a\#启用timewait 快速回收' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_tw_recycle = 1' /etc/sysctl.conf
sed -i '$a\#开启重用。允许将TIME-WAIT sockets 重新用于新的TCP 连接' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_tw_reuse = 1' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_mem = 94500000 915000000 927000000' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_fin_timeout = 1' /etc/sysctl.conf
sed -i '$a\#当keepalive 起用的时候，TCP 发送keepalive 消息的频度。缺省是2 小时' /etc/sysctl.conf
sed -i '$a\net.ipv4.tcp_keepalive_time = 30' /etc/sysctl.conf
sed -i '$a\#允许系统打开的端口范围' /etc/sysctl.conf
sed -i '$a\net.ipv4.ip_local_port_range = 1024    65000' /etc/sysctl.conf
sed -i '$a\#修改防火墙表大小，默认65536' /etc/sysctl.conf
sed -i '$a\#net.netfilter.nf_conntrack_max=655350' /etc/sysctl.conf
sed -i '$a\#net.netfilter.nf_conntrack_tcp_timeout_established=1200' /etc/sysctl.conf
sed -i '$a\# 确保无人能修改路由表' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.all.accept_redirects = 0' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.default.accept_redirects = 0' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.all.secure_redirects = 0' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.default.secure_redirects = 0' /etc/sysctl.conf
#设置最大打开文件描述符数
echo "ulimit -SHn 102400" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
*           soft   nofile       655350
*           hard   nofile       655350
EOF
#修改ulimit系统默认打开文件数和进程数
sed -i 's/#DefaultLimitNPROC=/DefaultLimitNPROC=655350/g' /etc/systemd/system.conf
sed -i 's/#DefaultLimitNOFILE=/DefaultLimitNOFILE=655350/g' /etc/systemd/system.conf
#优化ssh连接
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
#禁用防火墙
systemctl disable firewalld.service
systemctl stop firewalld.service
#禁用selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0
#
echo ""
echo -e "\033[31m本次优化结束,将在5秒后进行重启服务器，请注意\033[0m"
sleep 5s
#echo "成功."
reboot