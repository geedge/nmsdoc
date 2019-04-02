#!/bin/bash
#trap 'rm -rf /home/ceiec/oam;rm -rf /home/ceiec/collector;' EXIT
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

READ_NOTNULL_TEMP=""
function read_notNull(){
	echo -n "$1"
	stty erase '^H'
	read READ_NOTNULL_TEMP
	length=$#
	if [[ length -gt 1 ]]; then #参数大于1个，验证输入是否正确
		#statements
		FLAG=0
		while [[ true ]]; do
			#statements
			for i in "$@"; do 
				if [[ "$READ_NOTNULL_TEMP" = "$i" ]]; then
					#statements
					FLAG=1
					break
				fi
			done 
			if [[ "$FLAG" = 1 ]]; then
				#statements
				break
			else
				echo "input failed,please input again！"
				echo -n "$1"
		     	read READ_NOTNULL_TEMP
			fi
		done
		 
		
	else
		while [ -z "$READ_NOTNULL_TEMP" ]
		 do
		 	 echo "input is empty,please input again！"
		     echo -n "$1"
		     read READ_NOTNULL_TEMP
		done
	fi
	
}


function modify_file(){
	if [ $# != 2 ]
		 then
		 	echo "usage: modify_file [prop_name] [prop_value]"
		 	exit 0 
	fi
	prop_name="$1"
	prop_value="$2"
	echo "modify_file $PROP_FILE: $prop_name $prop_value"
	if [ -z "$(cat $PROP_FILE |grep $prop_name)" ]
		then
			echo "" >> $PROP_FILE
	    echo "$prop_name=$prop_value" >> $PROP_FILE
	else
			sed -i "s|^$prop_name.*|$prop_name=$prop_value|" $PROP_FILE
	fi
}

#当前目录
temp=`dirname $0`
CURDIR=`cd $temp;pwd`

#设备类型
DEVICE='ADC-A016'
#java打包程序路径
PROC_PATH=${CURDIR}"/process/oam.zip"
#脚本及配置文件路径
SCRIPT_HOME=${CURDIR}"/A016/master/script"
#安装路径
OAM_HOME="/home/ceiec"
#配置文件路径
CONFIG_FILE="/home/ceiec/oam/conf/config.properties"
read_notNull 'please input device type[ASEM-T102/ADC-A016](t/a):' t a
device_type="$READ_NOTNULL_TEMP"

is_master="1"
#安装类型标志 1 A106 master 2 A106 slave 3 T102
role=-1
DB_FILE="oam.db.A016"
if [ "t" = "$device_type" ];then 
	DEVICE="ASEM-T102"
	SCRIPT_HOME=${CURDIR}"/T102/script"
	DB_FILE="oam.db.T102"
	role=3
else
	role=1
	read_notNull 'please input install as master or slave (m/s)' m s
	flag="$READ_NOTNULL_TEMP"
	#echo "$flag"
	if [ "s" = "$flag"  ];then
		is_master="0"
		role=2
	fi
fi
#echo "is_master:$is_master"
#安装java程序
if [ "$is_master" = "1" ];then
	pinfo green "install oam program..."
	unzip $PROC_PATH -d $OAM_HOME >/dev/null
	if [ $? = 1 ];then 
		pinfo red "install FAILD."
		exit 0
	fi
	PROP_FILE="$CONFIG_FILE"
	modify_file 'equipment_name' $DEVICE
	
	cp ${CURDIR}"/db/$DB_FILE" ${OAM_HOME}"/oam/db/oam.db"
	read_notNull 'start oam right now?(y/n)' y n
	start="$READ_NOTNULL_TEMP"
	if [ "$start" = 'y'  ];then
		pinfo green "now start program..."
		bash ${OAM_HOME}"/oam/shell/startup.sh" >/dev/null 2>$1
		if [ $? = 0 ];then 
			pinfo green "start SUCCESS"
		else
			pinfo red "start FAILD.check \"$OAM_HOME/oam/log/gloam.log\" for help..."
			exit 0
		fi
	else
		echo "please start program with \"$OAM_HOME/oam/shell/startup.sh\""
	fi
fi

enter_password=""
function readPasswd(){
    enter_password=""
	  stty -echo cbreak erase '^H' 
		while true  
		do  
	        character=$(dd if=/dev/tty bs=1 count=1 2> /dev/null)  
	        case $character in  
	        $(echo -e "\n"))  
	                break  
	                ;;  
	        $(echo -e "\b"))  
	                if [ -z "$enter_password" ]; then  
	                        echo -n -e "\b \b"  
	                        enter_password=$(echo "$password" | sed 's/.$//g')  
	                fi  
	                ;;  
	        *)  
	                enter_password=$enter_password$character  
	                echo -n '*'  
	                ;;  
	        esac  
		done   
		stty -cbreak echo
		echo ""
}

enter_info=""
function readInfo_notNull(){
	if [ $# != 1 ];then
		echo "usage:readInfo_notNull [hint]"
		exit 1
	fi
	hint="$1"
	stty erase '^H'
        read -p "$hint:" enter_info
        while [ -z "enter_info" ];do
               read -p "this parameter is must,please input again:" enter_info
        done

}
NODE_ID=""
function getNodeIdByIP(){
	if [ $# != 1 ];then
		echo "usage:getNodeIdByIP [node_ip]"
		exit 1
	fi
	node_ip="$1"
	NODE_ID=$(sqlite3 ${CURDIR}"/db/$DB_FILE" <<EOF |awk '{print $0}'
        select id from node_table where ip="$node_ip";
EOF
)
echo "NODE_ID=$NODE_ID"
}

#安装脚本程序方法
function installScript(){
	if [ $# != 1  ];then
		echo "usage:installScript [script_dir]"
	fi
	script_dir=$1
	
	read -p "please input script file home[default /home/ceiec]:" script_home
	if [ -z "$script_home" ];then
		script_home="/home/ceiec"
	else
		if [ ! -d "$script_home" ];then
			mkdir -p "$script_home"
		fi
	fi
	
	#echo "$script_home"
	unzip ${script_dir}"/collector.zip" -d "$script_home" >/dev/null
	if [ $? != 0  ];then
		pinfo red "script file unzip FAILD"
		exit 1
	fi
	cd ${script_home}"/collector"
	#修改主机配置文件config
	if [[ -f config ]];then
		for i in 1 2 3 4
		do
			ipinfo=$(sqlite3 ${CURDIR}"/db/"${DB_FILE} <<EOF |awk -va="$i" 'NR==a{print $0}'
       		 	select ip||","||user||","||pwd from node_table;
EOF
)
			#写入配置
			PROP_FILE="$script_home/collector/config"
			modify_file 'ip'${i} "$ipinfo"
			if [ "t" = "$device_type" ];then
				break
			fi
		done
	
		#key src_dir
		srcDir="$script_home"
			
		#key dest_dir
		destDir="$script_home"

		#写入配置
		PROP_FILE="$script_home/collector/config"
		modify_file 'src_dir' "$srcDir"
		modify_file 'dest_dir' "$destDir"
	fi
	#为脚本授权
	chmod +x *.sh
	if [ -f expect_scp ];then
		chmod +x expect_scp
	fi
	
	#新建定时任务
	if [ -z "$(grep "$script_home/collector/getSingleMacInfo.sh" /var/spool/cron/root | grep -v 'grep' 2>/dev/null)" ];then
		echo "*/5 * * * * $script_home/collector/getSingleMacInfo.sh" >>/var/spool/cron/root
	fi
	
	if [[ -f ${script_home}"/collector/merge.sh" && -z "$(grep "$script_home/collector/merge.sh" /var/spool/cron/root |grep -v 'grep' 2>/dev/null)" ]];then
		echo "*/1 * * * * $script_home/collector/merge.sh">>/var/spool/cron/root
	fi

	#处理configs目录下配置文件
	cd ${script_home}"/collector/configs"
	<<UNUSE
	cpu="cpu_cpu.cfg"
	disk="disk_disk.cfg"
	mem="memory_memory.cfg"
	net="net_net.cfg"
	sys="systeminfo_servicessysinfo.cfg"
UNUSE
	#获取node_table的id
	readInfo_notNull "please input the localhost"
	#只针对ADC-A016 
	ip="$enter_info"
	getNodeIdByIP "$ip"
	while [ -z "$NODE_ID" ];do
		 #获取node_table的id
	         readInfo_notNull "this ip is not exist,please input the device ip again"
       		 #只针对ADC-A016
        	 ip="$enter_info"
        	 getNodeIdByIP "$ip"

	done
	node_id="$NODE_ID"
	for file in *
	do 
		temp=$(awk 'NR==1{print $0}' $file|cut -d'=' -f2)
		value=${node_id}${temp}
		PROP_FILE=$(readlink -f "$file")
		modify_file 'pubInfo' "$value"
	done
	
	#处理device_config 脚本
	if [ ! -f '/usr/local/bin/device_config' ];then
		cp $script_dir/device_config /usr/local/bin
		if [ $? = 0 ];then
			chmod +x /usr/local/bin/device_config	
		fi
	fi



}

#安装脚本程序
case $role in 
1 )
	installScript "$SCRIPT_HOME"
;;
2 )	
	SCRIPT_HOME="${CURDIR}/A016/slave"
	installScript "$SCRIPT_HOME"
;;
3 )
	SCRIPT_HOME="${CURDIR}/T102/script"
	installScript "$SCRIPT_HOME"
;;

* )
	pinfo red "`basename $0` exec error "
	exit 1
;;
esac




