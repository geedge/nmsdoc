#!/bin/bash

PRG="$0" #当前文件的文件名
PRGDIR=`dirname "$PRG"`
CUR_PRGDIR=`cd "$PRGDIR"; pwd` #当前文件的路径

#设置默认安装目录,必填项
INSTALL_DIR="/home/ceiec/nms"

#tomcat默认目录
TOMCAT_HOME="$INSTALL_DIR/nmsweb"

#默认数据库名
DEFAULT_DB_NAME="nms"
#初始化数据库时创建的用户名 密码，web程序，dc程序连接的数据库用户名 密码
DB_USER="nms"
DB_PASSWORD="nms"

#数据库管理员帐号密码，当初始化数据库时为必填项
DB_ADMIN_USER=""
DB_ADMIN_PASSWORD=""


#数据库服务器的ip地址
DB_HOST=""
#数据库服务监听的端口mysql是3306
DB_PORT=""
#数据库url
DB_URL=""


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
	echo "modify_file $prop_name $prop_value"
	if [ -z "$(cat $PROP_FILE |grep $prop_name)" ]
		then
			echo "" >> $PROP_FILE
	    echo "$prop_name=$prop_value" >> $PROP_FILE
	else
			sed -i "s|^$prop_name.*|$prop_name=$prop_value|" $PROP_FILE
	fi
}



#jre
NMS_JDK="$INSTALL_DIR/nmsjdk"
JDK_DIR="$INSTALL_DIR/jre1.7.0_80"
JDK_BIN_FILE=$CUR_PRGDIR"/jre_install/jre-7u80-linux-i586.tar.gz"
if [ "`uname -i`" = "x86_64" ];then
	JDK_BIN_FILE=$CUR_PRGDIR"/jre_install/jre-7u80-linux-x64.tar.gz"
fi

if [ ! -e "$NMS_JDK" ]
		then
		  pinfo yellow  "JDK bin file: $JDK_BIN_FILE" 
	          pinfo yellow "now, install jdk: $JDK_DIR"
		  sleep 3
		  if [ ! -e "$JDK_DIR" ];then 
		   mkdir -p $JDK_DIR
		   fi
		  tar -xzf $JDK_BIN_FILE -C $JDK_DIR --strip-components=1 
		  ln -s $JDK_DIR $NMS_JDK
      pinfo green "install jdk done"
fi

echo "==========================================="
pinfo yellow "NMS_JDK: $NMS_JDK"
pinfo yellow "INSTALL_DIR: $JDK_DIR"
echo "==========================================="
time=`date "+%Y%m%d%H%M%S"`
function init_sync_db() {
	cp -f ${CUR_PRGDIR}/DB_init/initData_master.sql ${CUR_PRGDIR}"/DB_init/initData_master.sql.bak"${time}
                cp -f ${CUR_PRGDIR}/DB_init/initData_slave.sql ${CUR_PRGDIR}"/DB_init/initData_slave.sql.bak"${time}

		sql="TRUNCATE TABLE \`sync_db_info\`;"
		echo "$sql" >> ${CUR_PRGDIR}/DB_init/initData_master.sql.bak${time}
        echo "$sql" >> ${CUR_PRGDIR}/DB_init/initData_slave.sql.bak${time}
        for info in `cat region_info`
        do
                ip=`echo "$info"|awk -F "," '{print $1}'`
                port=`echo "$info"|awk -F "," '{print $2}'`
                db_name=`echo "$info"|awk -F "," '{print $3}'`
                user=`echo "$info"|awk -F "," '{print $4}'`
                pwd=`echo "$info"|awk -F "," '{print $5}'`
				master=`echo "$info"|awk -F "," '{print $6}'`
                sql="insert into \`sync_db_info\` (\`ip\`,\`port\`,\`database_name\`,\`user\`,\`password\`,\`master\` ) values ('${ip}',${port},'${db_name}','${user}','${pwd}','${master}' );"
                
                echo "$sql" >> ${CUR_PRGDIR}/DB_init/initData_master.sql.bak${time}
                echo "$sql" >> ${CUR_PRGDIR}/DB_init/initData_slave.sql.bak${time}

        done
}


read_notNull "Init Database?(y/n):" y n
INIT_DB="$READ_NOTNULL_TEMP"
if [ "$INIT_DB" = "y" ]; then 
	
	#initData.sql文件路径
	DB_INITDATABASE="${CUR_PRGDIR}/DB_init/initDatabase.sql"
	DB_INITDATA="${CUR_PRGDIR}/DB_init/initData.sql"
	
	read_notNull "Is 'Nation @ Region' model?(y/n):" y n
	NR_MODEL="$READ_NOTNULL_TEMP"
	
	#如果是国家中心、分中心模式，需要初始化同步数据
	if [ "$NR_MODEL" = "y" ];then 
		
		#初始化sync_db_info表的数据
		init_sync_db 
		read_notNull "Is 'Nation Center' ?(y/n):" y n
        	NATION="$READ_NOTNULL_TEMP"
		if [ "$NATION" = "y" ];then
			DB_INITDATABASE="${CUR_PRGDIR}/DB_init/initDatabase_master.sql"
			DB_INITDATA="${CUR_PRGDIR}/DB_init/initData_master.sql.bak${time}"
		else
			DB_INITDATABASE="${CUR_PRGDIR}/DB_init/initDatabase_slave.sql"
                        DB_INITDATA="${CUR_PRGDIR}/DB_init/initData_slave.sql.bak${time}"
		fi
	fi
	
	if [ -z "$DB_HOST" ]; then
		read_notNull "please input DB host: "
		DB_HOST="$READ_NOTNULL_TEMP"
	fi	

	read -p "please input DB port[default 3306]: " port
	if [[ ! -z "$port"  ]]; then 
		DB_PORT="$port"
	else
		DB_PORT="3306"
	fi

	read_notNull "please input DB admin username："
	DB_ADMIN_USER="$READ_NOTNULL_TEMP"
	
	read_notNull  "please input DB admin password："
	DB_ADMIN_PASSWORD="$READ_NOTNULL_TEMP"
	
	if [ -z "$DB_USER" ]; then #数据库新建用户用户名
		read_notNull "please input username for new Database："
		DB_USER="$READ_NOTNULL_TEMP"
	fi

	if [ -z "$DB_PASSWORD" ]; then #数据库新建用户密码
		read_notNull  "please input password for new Database："
        	DB_PASSWORD="$READ_NOTNULL_TEMP"
	fi

	#crate database
	mysql -u$DB_ADMIN_USER -p$DB_ADMIN_PASSWORD -h$DB_HOST -P$DB_PORT<< EOF 2>/dev/null
		drop database if exists $DEFAULT_DB_NAME; #首先确保$DEFAULT_DB_NAME不存在
		 CREATE DATABASE $DEFAULT_DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci; #新建数据库
EOF
	[ $? -eq 0 ] && echo "CREATE DATABASE SUCCESS" || echo "CREATE DATABASE FAILURE"
	
	#crate user
	mysql -u$DB_ADMIN_USER -p$DB_ADMIN_PASSWORD -h$DB_HOST -P$DB_PORT<< EOF 2>/dev/null
		insert into mysql.user(Host,User,Password) values("localhost","$DB_USER",password("$DB_PASSWORD")); #新建用户
		insert into mysql.user(Host,User,Password) values("%","$DB_USER",password("$DB_PASSWORD")); #新建用户
		flush privileges;
EOF
	[ $? -eq 0 ] && echo "CREATED USER SUCCESS" || echo "CREATED USER FAILURE"
	
	#grant
	mysql -u$DB_ADMIN_USER -p$DB_ADMIN_PASSWORD -h$DB_HOST -P$DB_PORT<< EOF 2>/dev/null
		grant all privileges on $DEFAULT_DB_NAME.* to $DB_USER@localhost identified by "$DB_PASSWORD";
		grant all privileges on $DEFAULT_DB_NAME.* to $DB_USER@'%' identified by "$DB_PASSWORD";
		flush privileges;
EOF
	[ $? -eq 0 ] && echo "GRANT SUCCESS" || echo GRANT FAILURE
	
	sleep 3
	
	#导入表结构和数据
	mysql -u$DB_ADMIN_USER -p$DB_ADMIN_PASSWORD -h$DB_HOST -P$DB_PORT $DEFAULT_DB_NAME < $DB_INITDATABASE
	[ $? -eq 0 ] && echo "INIT DATABASE SUCCESS" || echo "INIT DATABASE FAILURE"
	
	 mysql -u$DB_ADMIN_USER -p$DB_ADMIN_PASSWORD -h$DB_HOST -P$DB_PORT $DEFAULT_DB_NAME < $DB_INITDATA
        [ $? -eq 0 ] && echo "INIT DATA SUCCESS" || echo "INIT DATA FAILURE"
	
	if [ "$NATION" = "y" ];then
	
	sleep 3
	
        mysql -u$DB_ADMIN_USER -p$DB_ADMIN_PASSWORD -h$DB_HOST -P$DB_PORT << EOF 2>/dev/null
                use $DEFAULT_DB_NAME;
                call pro_init_table_sync_info;
EOF
        [ $? -eq 0 ] && echo "INIT TABLE_SYNC_INFO SUCCESS" || echo "INIT TABLE_SYNC_INFO FAILURE"
	
	fi

	sleep 3	
	
	mysql -u$DB_ADMIN_USER -p$DB_ADMIN_PASSWORD -h$DB_HOST -P$DB_PORT << EOF 2>/dev/null
		use $DEFAULT_DB_NAME;
                call pro_driver_add_Partition;
EOF
	[ $? -eq 0 ] && echo "CREATE PARTITION SUCCESS" || echo "CREATE PARTITION FAILURE"
	echo "==========================================="
	pinfo yellow "DATABASE: $DEFAULT_DB_NAME"
	pinfo yellow "DB USERNAME: $DB_USER"
	echo "==========================================="

fi

if [ -z "$DB_HOST" ]; then
       DB_HOST="127.0.0.1"
fi

if [[ -z "$DB_PORT"  ]]; then
       DB_PORT="3306"
fi

DB_URL="jdbc:mysql://${DB_HOST}:${DB_PORT}/${DEFAULT_DB_NAME}?useUnicode=true\&characterEncoding=utf-8\&useOldAliasMetadataBehavior=true"

NMSWEB_HOME="$TOMCAT_HOME/webapps/nmsweb"
function writeConfig(){
	
	#修改jdbc文件
	PROP_FILE=$NMSWEB_HOME/WEB-INF/classes/hibernate/jdbc.properties
	
	modify_file "jdbc.url" $DB_URL
	modify_file "jdbc.username" $DB_USER
	modify_file "jdbc.password" $DB_PASSWORD

}


read_notNull "Install nmsweb?(y/n):" y n
INSTALL_WEB="$READ_NOTNULL_TEMP"
if [ "$INSTALL_WEB" = "y" ]; then

	WEB_PATH="${CUR_PRGDIR}/WEB/nmsweb.tar.gz"
	
	if [ ! -e "$TOMCAT_HOME" ]; then
        	mkdir -p $TOMCAT_HOME
		
	fi
	pinfo yellow "now install web ..."

	tar -xzf $WEB_PATH -C $TOMCAT_HOME --strip-components=1 >/dev/null
	
	if [ $? -eq 0 ]; then
		
		#将tomcat加入自启动
		if [ -z "$(cat /etc/rc.local|grep "$TOMCAT_HOME/bin/startup.sh")" ]
		then
	   		echo "$TOMCAT_HOME/bin/startup.sh" >> /etc/rc.local 
			chmod +x /etc/rc.local
		fi
		
		if [[ "$NR_MODEL" = "y" && "$NATION" = "n" ]];then
                        echo "region.role.jsbh=21" >> ${TOMCAT_HOME}/webapps/nmsweb/WEB-INF/classes/myconfig.properties
               # else 
                #        PROP_FILE=$NMSWEB_HOME/WEB-INF/classes/myconfig.properties

                 #       modify_file "dc.notice" "1"

                fi

	
		writeConfig		

		echo "##############################################"
		pinfo green "install WEB successed..."
		pinfo yellow "install path: $TOMCAT_HOME"
		echo "##############################################"
		
		#启动tomcat
		read_notNull "Start WEB right now？(y/n):" y n
		WEB_START="$READ_NOTNULL_TEMP"
		if [[ "$WEB_START" = "y" ]]; then
			sh $TOMCAT_HOME/bin/startup.sh
			[ $? -eq 0 ] && pinfo green "tomcat start success" || pinfo red "tomcat start failure"
		else
			echo "please use [$TOMCAT_HOME/bin/startup.sh] to run the web program..."
		fi		
	else
		echo "##############################################"
                pinfo red "install WEB failure..."
                echo "##############################################"
		
	fi
	
fi

















