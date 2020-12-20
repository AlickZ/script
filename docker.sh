#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin                                                                                             
#===================================================================#
#   System Required:  CentOS 7                                      #
#   Description: Install sspanel for CentOS7                        #
#   Author: ACL <563396148@qq.com>                                #
#===================================================================#
#一键脚本
#version=v1.1
#check root
[ $(id -u) != "0" ] && { echo "错误:请以root用户运行此脚本"; exit 1; }
rm -rf all
rm -rf $0
IP=$(curl ip.sb)
#
# 设置字体颜色函数
function blue(){
    echo -e "\033[34m\033[01m $1 \033[0m"
}
function green(){
    echo -e "\033[32m\033[01m $1 \033[0m"
}
function greenbg(){
    echo -e "\033[43;42m\033[01m $1 \033[0m"
}
function red(){
    echo -e "\033[31m\033[01m $1 \033[0m"
}
function redbg(){
    echo -e "\033[37;41m\033[01m $1 \033[0m"
}
function yellow(){
    echo -e "\033[33m\033[01m $1 \033[0m"
}
function white(){
    echo -e "\033[37m\033[01m $1 \033[0m"
}

#            
# @安装docker
install_docker() {
    docker version > /dev/null || curl -fsSL get.docker.com | bash 
    service docker restart 
    systemctl enable docker  
}

# 单独检测docker是否安装，否则执行安装docker。
check_docker() {
	if [ -x "$(command -v docker)" ]; then
		blue "docker is installed"
		# command
	else
		echo "Install docker"
		# command
		install_docker
	fi
}

#工具安装
install_tool() {
    echo "===> Start to install tool"    
    if [ -x "$(command -v yum)" ]; then
        command -v curl > /dev/null || yum install -y curl
        systemctl stop firewalld.service
        systemctl disable firewalld.service
    elif [ -x "$(command -v apt)" ]; then
        command -v curl > /dev/null || apt install -y curl
    else
        echo "Package manager is not support this OS. Only support to use yum/apt."
        exit -1
    fi 
}

confim_docker() {
    echo "===> 开始确认基础环境"    
    if [ -x "$(command -v yum)" ]; then
        command -v docker > /dev/null || echo 'Docker环境安装失败，请更换系统重试！多次无效联系作者'
    elif [ -x "$(command -v apt)" ]; then
        command -v docker > /dev/null || echo 'Docker环境安装失败，请更换系统重试！多次无效联系作者'
    else
        echo "Package manager is not support this OS. Only support to use yum/apt."
        exit -1
    fi 
}



# 以上步骤完成基础环境配置。#开始菜单
echo "恭喜，您已完成基础环境安装，可执行安装程序。"

start_zh(){
    clear
	echo
    greenbg "==============================================================="
	greenbg "1.安装docker                             2.卸载docker          "	
    greenbg "==============================================================="		
    echo
    read -p "请输入数字,退出请按0:" zh
    case "$zh" in
    1)
    yellow "正在部署docker。。。。"
    start=$(date "+%s")
    install_tool
    check_docker
    confim_docker
	greenbg "恭喜您，docker已安装成功"
    end=$(date "+%s")
    echo 安装总耗时:$[$end-$start]"秒"
	;;
    2)
    greenbg "正在卸载docker"
	start=$(date "+%s")
    yum remove -y docker-*
    rm -rf /var/lib/docker
	greenbg "恭喜您，docker卸载成功！再见"
	echo 安装总耗时:$[$end-$start]"秒"
	;;
	0)
	exit 1
	;;
	*)
	clear
	echo "请输入正确数字,退出请按0："
	sleep 3s
	start_zh
	;;
    esac
}

start_zh


