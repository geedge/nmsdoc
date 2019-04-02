#!/bin/bash
#带颜色输出内容
#$1 颜色 red green yellow  警告 red  成功 green 提示/输入 yellow
#$2 输出语句
#$3 -n y/n 是否换行输出
function pinfo(){ 
        LINE=""
        if [[ "$#" -gt 2 ]]; then
                #statements
                if [[ "$3" = "n" ]]; then
                        #statements
                        LINE="-n"
                fi
        fi
        case $1 in
                "red")
                        echo -e $LINE "\e[1;31m "${2}"\e[0m"
                ;;
                "green")
                        echo -e $LINE "\e[1;32m "${2}"\e[0m"
                ;;
                "yellow")
                        echo -e $LINE "\e[1;33m "${2}"\e[0m"
                ;;
                "blue")
                        echo -e $LINE "\e[1;34m "${2}"\e[0m"
                ;;
                *)
                        echo $LINE $2
                ;;
        esac
}


if [[ "$#" < 2 ]]; then
	pinfo red "the script need parameters:dc host and node ip file ! "
	exit
fi

#IP_RE="((25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))"

IP_RE="^([0-9]{1,3}.){3}[0-9]{1,3}$"

#dc的ip
DC_HOST="$1"
#保存需要安装nc机器ip的文件
NODE_FILE="$2"
#nc安装目录
INSTALL_DIR="/home/ceiec/nms"

if [[ "$DC_HOST" =~ $IP_RE ]]; then
	echo -n ""
else
	pinfo red "the first parameter dc host is invalid!"
	exit
fi

(head "$NODE_FILE" >/dev/null 2>&1) 

if [[ "$?" == 1 ]];then 
	pinfo red "the second parameter node ip file is invalid!"
	exit
fi 

#当前目录
TEMP=`dirname "$0"`
CUR_DIR=`cd "$TEMP";pwd` 

#nc压缩包
NCNAME="nmsclient.tar.gz"
#jre压缩包
JRENAME="jre-7u80-linux-i586.tar.gz"

if [ "`uname -i`" = "x86_64" ];then
        JRENAME="jre-7u80-linux-x64.tar.gz"
fi

#绝对路径
NCFILE=${CUR_DIR}"/"${NCNAME}
JREFILE=${CUR_DIR}"/"${JRENAME}


#jre安装目录
JRE_DIR="jre1.7.0_80"

if [[ ! -f "$NCFILE" ]];then
	pinfo red "the nmsclient file is not exist!"
	exit
fi

if [[ ! -f "$JREFILE" ]];then
        pinfo red "the jre file is not exist!"
        exit
fi

pinfo yellow  "安装程序准备就绪···"
echo "========================================================="
pinfo yellow "开始拷贝jre文件···"
pscp -h "$NODE_FILE" "$JREFILE" /home
pinfo green "拷贝jre文件完成！"
echo "========================================================="
pinfo yellow "开始拷贝NC安装程序···"
pscp -h "$NODE_FILE" "$NCFILE" /home 
pinfo green "NC安装程序拷贝完成！"
echo "========================================================="

function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(date +%s%N)
    echo $(($num%$max+$min))
}

pinfo yellow "开始安装NC···"
echo "========================================================="
prop_name="server_host"
PROP_FILE=${INSTALL_DIR}"/nmsclient/conf/myconfig.properties"
pssh  -i -t 60 -h "$NODE_FILE" "mkdir -p ${INSTALL_DIR};mv /home/${NCNAME} ${INSTALL_DIR};tar -xzf  ${INSTALL_DIR}/${NCNAME} -C ${INSTALL_DIR};mkdir -p ${INSTALL_DIR}/${JRE_DIR};mv /home/${JRENAME} ${INSTALL_DIR};tar -xzf ${INSTALL_DIR}/${JRENAME} -C ${INSTALL_DIR}/${JRE_DIR} --strip-components=1 ;ln -s ${INSTALL_DIR}/${JRE_DIR} ${INSTALL_DIR}/nmsjdk; sed -i 's|^$prop_name.*|$prop_name=$DC_HOST|' $PROP_FILE;echo '5-20 秒后启动nmsclient~';sleep  $(rand 5 20);bash ${INSTALL_DIR}/nmsclient/shell/startup.sh;echo ${INSTALL_DIR}'/nmsclient/shell/startup.sh'>>/etc/rc.d/rc.local;chmod +x /etc/rc.d/rc.local;" 2>>error.log
pinfo green "程序安装完成！"


