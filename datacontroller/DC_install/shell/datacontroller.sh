#!/bin/sh

# -----------------------------------------------------------------------------
# Start/Stop Script for the DATACONTROLLER Server
#
# Environment Variable Prequisites
#
#   DATACONTROLLER_HOME   May point at your DATACONTROLLER "build" directory.
# -----------------------------------------------------------------------------

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
 
PRGDIR=`dirname "$PRG"`

# Only set DATACONTROLLER_HOME if not already set
[ -z "$DATACONTROLLER_HOME" ] && DATACONTROLLER_HOME=`cd "$PRGDIR/.." ; pwd`
cd "$DATACONTROLLER_HOME"/shell

if [ -z "$DATACONTROLLER_TMPDIR" ] ; then
  DATACONTROLLER_TMPDIR="$DATACONTROLLER_HOME"/temp
fi
if [ ! -d $DATACONTROLLER_TMPDIR ]
   then
      mkdir $DATACONTROLLER_TMPDIR
fi

# -------- check jdk
# check nmsjdk
NMS_HOME=`cd "$DATACONTROLLER_HOME/.." ; pwd`
cd "$DATACONTROLLER_HOME"/shell
NMS_JDK="$NMS_HOME"/nmsjdk
if [ ! -e "$NMS_JDK" ]
  then 
    echo "$NMS_JDK not exist"
    exit 0
fi
# check java -version
javaversion=`$NMS_JDK/bin/java -version 2>&1|grep "java version"`
if [ ! -n "$javaversion" ]
  then
    echo "$NMS_JDK cannot use, please install"
    exit 0
fi

# -------- set jdk path
export JAVA_HOME=$NMS_JDK
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$JAVA_HOME/bin:$PATH

temp=$CLASSPATH
#setting libs path
libs="$DATACONTROLLER_HOME"/lib/*
append(){
    temp=$temp":"$1
}
for file in $libs;    do
    append $file                
done
jars="$DATACONTROLLER_HOME"/bin/*
for file in $jars;    do
    append $file                
done
export DC_CLASSPATH=$temp:.:$DATACONTROLLER_HOME/conf
export LD_LIBRARY_PATH=$DATACONTROLLERT_HOME/lib
export LANG=zh_CN.UTF-8

echo "Using DATACONTROLLER_HOME:   $DATACONTROLLER_HOME"
echo "Using DATACONTROLLER_TMPDIR:  $DATACONTROLLER_TMPDIR"
echo "Using JAVA_HOME:       $JAVA_HOME"
echo "Using CLASSPATH:       $DC_CLASSPATH"

# ---- get jvm param
jvmconf_file=$DATACONTROLLER_HOME"/conf/jvm.conf"
if [ -f $jvmconf_file ]
	then
		XmsOpt=`sed -n '/-Xms/p' $jvmconf_file`
		XmxOpt=`sed -n '/-Xmx/p' $jvmconf_file`
		JAVA_OPTS="$XmsOpt $XmxOpt -XX:+UseParNewGC"
else
    JAVA_OPTS="-Xms64m -Xmx256m -XX:+UseParNewGC"
fi

program="com.nms.server.DataController"
name="DataController"

proc_id=

writePid()
{
	 ps aux|grep java|grep $program|grep -v grep|awk '{print $2}' > $DATACONTROLLER_TMPDIR/serverPid.temp
}
getPid()
{
	 unset proc_id
   proc_id=`ps aux|grep java|grep $program|grep -v grep|awk '{print $2}'`
}

if [ "$1" = "start" ] ; then
	getPid
	if [ -n "$proc_id" ]
     then
        echo "$name already running......"
	else   
				nohup java $JAVA_OPTS -classpath $DC_CLASSPATH  $program >/dev/null &      
        sleep 3
        getPid
        if [ -n "$proc_id" ]
             then
                 echo "$name start success!!!!!"
                 writePid
        else
             echo "$name start error!!!!!"
        fi
  fi
elif [ "$1" = "stop" ]; then
   getPid
   if [ -n "$proc_id" ]
       then
           echo "$name is start, now kill......"
           kill -15  $proc_id
           sleep 3
           writePid
           echo "$name kill ok !!!!!!!!!!!!!"    
   else
       echo "$name is not start!!!!!!!!!!!"
   fi 
elif [ "$1" = "restart" ] ; then
	 getPid
   if [ -n "$proc_id" ]
       then
           echo "`date +%Y-%m-%d" "%H:%M:%S` :$name is start, now restart......"  >> $DATACONTROLLER_TMPDIR/job.log
           count=1
		   while [ $count -le 3 ]
		   do
	           sleep 1
	           kill -15  $proc_id
	           sleep 1
	           getPid
					   if [ -n "$proc_id" ]
					      then
					        echo "`date +%Y-%m-%d" "%H:%M:%S` :$name stop error!!!!!!!!!!" >> $DATACONTROLLER_TMPDIR/job.log
					   else
					      echo "`date +%Y-%m-%d" "%H:%M:%S` :$name stop success!!!!!!!!!!" >> $DATACONTROLLER_TMPDIR/job.log
					      break
					   fi  
			   count=$count+1
		   done
		   
		   getPid
		   if [ -n "$proc_id" ]
		      then
		        sleep 1
		        kill -9  $proc_id
		        getPid
			        if [ -n "$proc_id" ]
			          then
				      	echo "`date +%Y-%m-%d" "%H:%M:%S` :$name stop -9 error!!!!!!!!!!" >> $DATACONTROLLER_TMPDIR/job.log
				        exit 1
			        fi  
		   fi  
				  
   else
       echo "`date +%Y-%m-%d" "%H:%M:%S` :$name is not start, now start......" >> $DATACONTROLLER_TMPDIR/job.log
   fi
     
   #--------copy right, start proc
   nohup java $JAVA_OPTS -classpath $DC_CLASSPATH  $program >/dev/null &     
   sleep 3
     getPid
	   if [ -n "$proc_id" ]
	      then
	      writePid
	      echo "`date +%Y-%m-%d" "%H:%M:%S` :$name restart success!!!!!!!!!!" >> $DATACONTROLLER_TMPDIR/job.log
	   else
	     echo "`date +%Y-%m-%d" "%H:%M:%S` :$name restart error!!!!!!!!!!" >> $DATACONTROLLER_TMPDIR/job.log
	   fi
 
else
   echo "Usage: datacontroller.sh ( commands ... )"
   echo "commands:"
   echo "  start             Start $name"
   echo "  stop              Stop $name"
   echo "  restart   		 ReStart $name in a separate window"
fi

cd -
