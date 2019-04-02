#!/bin/bash

DEFAULT_DATA_DIR="/home/ceiec/nms/nmsdata"
DEFAULT_INSTALL_DIR="/home/ceiec/nms/datacontroller"

# --- set install dir
PRG="$0"
PRGDIR=`dirname "$PRG"`
CUR_PRGDIR=`cd "$PRGDIR"; pwd`

if [ $# = 0 ]
	then
	  echo -n "enter intall dir [default: $DEFAULT_INSTALL_DIR]:"
		read INSTALL_DIR
		if [ -z "$INSTALL_DIR" ]; then
				INSTALL_DIR="$DEFAULT_INSTALL_DIR"
		fi
else
   INSTALL_DIR="$1"
fi

if [ ! -d $INSTALL_DIR ]
	then
		mkdir -p $INSTALL_DIR
fi 

INSTALL_DIR=`cd "$INSTALL_DIR"; pwd`

# --- check jdk and jdk-version
install_jdk=0
javaversion=`java -version 2>&1|grep "java version"`
if [ -n "$javaversion" ]
	then
	#	javaversion=${javaversion:14:3}
		javavmajor=`echo $javaversion | cut -c15`
		javavminor=`echo $javaversion | cut -c17`
#		OS_TYPE=$( lsb_release -d| cut -d: -f2| cut -f2 )
#		if [ "`echo $OS_TYPE | cut -c1-6`" = "Ubuntu" ]
#			then
#			if [ 2 -gt $javavmajor ]; then
#				if [ 6 -gt $javavminor ]; then
#				install_jdk=1
#				fi
#			fi
#		else
			if [[ 2 -gt $javavmajor && 6 -gt $javavminor ]]; then
			install_jdk=1
			fi
#		fi 
	else   
		install_jdk=1
fi

# --- install jdk
cd "$INSTALL_DIR"/..
NMS_JDK="$(pwd)/nmsjdk"
JDK_DIR="$(pwd)/jre1.7.0_80"
JDK_BIN_FILE=$CUR_PRGDIR"/jre_install/jre-7u80-linux-i586.tar.gz"
if [ "`uname -i`" = "x86_64" ];then
	JDK_BIN_FILE=$CUR_PRGDIR"/jre_install/jre-7u80-linux-x64.tar.gz"
fi
if [ $install_jdk = 1 ]
  then
	if [ ! -e "$NMS_JDK" ]
		then
			echo "JDK bin file: $JDK_BIN_FILE" 
		  echo "now, install jdk: $JDK_DIR"
		  sleep 3
		  if [ ! -e "$JDK_DIR" ];then 
		   mkdir -p $JDK_DIR
		   fi
		  tar -xzf $JDK_BIN_FILE -C $JDK_DIR --strip-components=1 || installJdk=1
		  if [ -n "$installJdk" ];then
		  	echo "install jdk failure, exit program"
		  	exit 1
		  fi
		  ln -s $JDK_DIR $NMS_JDK
      echo "install jdk done"
	fi
elif [ -n "$JAVA_HOME" ];then
  ln -s $JAVA_HOME $NMS_JDK
else
	echo "JDK bin file: $JDK_BIN_FILE" 
  echo "now, install jdk: $JDK_DIR"
	sleep 3
	if [ ! -e "$JDK_DIR" ];then 
		   mkdir -p $JDK_DIR
	fi
	tar -xzf $JDK_BIN_FILE -C $JDK_DIR --strip-components=1 || installJdk=1
	if [ -n "$installJdk" ];then
		  echo "install jdk failure, exit program"
		  exit 1
	fi
	ln -s $JDK_DIR $NMS_JDK
  echo "install jdk done"
fi
cd "$CUR_PRGDIR"

echo "==========================================="
echo "NMS_JDK: $NMS_JDK"
echo "INSTALL_DIR: $INSTALL_DIR"
echo "==========================================="

# --- copy file to install_dir
if [ "$INSTALL_DIR" == "$CUR_PRGDIR" ]
   then
      echo "install directory is current program directory..."
else
	 echo "install program, it may take a few time..."
   CP_DIR=(
	    bin
	    lib
	    conf
	    shell
	)
	#cp 
	for CP_NAME in ${CP_DIR[@]}
	do
	     echo $CP_NAME
	     cp -a $CUR_PRGDIR"/$CP_NAME" $INSTALL_DIR
	done
fi

function modify_file(){
	if [ $# != 2 ]
		 then
		 	echo "usage: modify_file [prop_name] [prop_value]"
		 	exit 0 
	fi
	prop_name="$1"
	prop_value="$2"
	#echo "modify_file $prop_name $prop_value"
	if [ -z "$(cat $PROP_FILE |grep $prop_name)" ]
		then
			echo "" >> $PROP_FILE
	    echo "$prop_name=$prop_value" >> $PROP_FILE
	else
			sed -i "s|^$prop_name.*|$prop_name=$prop_value|" $PROP_FILE
	fi
}

enter_password=""
function readPasswd(){
    enter_password=""
	  stty -echo cbreak  
		while true  
		do  
	        character=$(dd if=/dev/tty bs=1 count=1 2> /dev/null)  
	        case $character in  
	        $(echo -e "\n"))  
	                break  
	                ;;  
	        $(echo -e "\b"))  
	                if [ -n "$enter_password" ]; then  
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

# modify property
PROP_FILE=$INSTALL_DIR"/conf/myconfig.properties"

#echo "PROP_FILE: $PROP_FILE"

#-------------data dir
echo -n "enter data dir [default $DEFAULT_DATA_DIR]: "
read data_path
if [ -z "$data_path" ]
   then
     data_path="$DEFAULT_DATA_DIR"
fi
#-------------local ip
echo -n "enter local ip: "
read local_ip
while [ -z "$local_ip" ]
	 do
     echo -n "local ip cannot null, please enter local ip: "
     read local_ip
done
#-------------nmsweb ip
echo -n "enter nmsweb ip: "
read nmsweb_ip
while [ -z "$nmsweb_ip" ]
	 do
     echo -n "nmsweb ip cannot null, please enter nmsweb ip: "
     read nmsweb_ip
done
#-------------db url
#echo -n "enter database url: "
#read db_url
#while [ -z "$db_url" ]
#	 do
#     echo -n "database url cannot null, please enter database url: "
#     read db_url
#done

#2018-08-26 修改url为只传host和port（默认3306）拼接完成后赋值给db.url
DBPORT=3306
#-------------db host
echo -n "enter database host:"
read db_host
while [ -z "$db_host" ]
do
	echo -n "database host cannot null,please enter database host:"
	read db_host
done

#-------------db port
echo -n "enter database port[default port 3306]:"
read db_port
if [ -z "$db_port" ]
then 
	db_port="$DBPORT"
fi

#-----------db url
db_url="jdbc:mysql://"${db_host}":"${db_port}"/nms?useUnicode=true\&characterEncoding=utf-8\&useOldAliasMetadataBehavior=true\&rewriteBatchedStatements=true"

#-------------db username
echo -n "enter database username: "
read db_username
while [ -z "$db_username" ]
	 do
     echo -n "database username cannot null, please enter database username: "
     read db_username
done
#-------------db password
echo -n "enter database password: "
readPasswd
db_passwd="$enter_password"
while [ -z "$db_passwd" ]
	 do
     echo -n "database password cannot null, please enter database password: "
     readPasswd
     db_passwd="$enter_password"
done
#-------------log4j dir
echo -n "enter logs path [default $data_path/dc_logs]:  "
read logs_path
if [ -z "$logs_path" ]
   then
     logs_path="$data_path/dc_logs"
fi

modify_file "common.datas.dir" $data_path
modify_file "system.inet.address" $local_ip
modify_file "web.socket.ip" $nmsweb_ip
modify_file "db.url" $db_url
modify_file "db.username" $db_username
modify_file "db.password" $db_passwd

# modify log4j
PROP_FILE=$INSTALL_DIR"/conf/log4j.properties"
encoding=${LANG#*.}
modify_file "log4j.appender.stdout.encoding" $encoding
modify_file "log4j.appender.debugAppender.encoding" $encoding
modify_file "log4j.appender.infoAppender.encoding" $encoding
modify_file "log4j.appender.debugAppender.File" "$logs_path/datacontroller_debug.log"
modify_file "log4j.appender.infoAppender.File" "$logs_path/datacontroller_info.log"

#permit
cd $INSTALL_DIR"/shell"
chmod 755 *.sh
cd $CUR_DIR

if [ -z "$(cat /etc/rc.local|grep $INSTALL_DIR"/shell/startup.sh")" ]
then
   echo $INSTALL_DIR"/shell/startup.sh" >> /etc/rc.local 
fi

echo "install successed..."
echo "please use [$INSTALL_DIR/shell/startup.sh] to run the program..."