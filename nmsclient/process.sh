#!/bin/bash
#if [ $# -eq 1 ]; then
#  diconf_file=$1
#else
#  echo "Missing monitor-config-file info!"
#  exit 1
#fi


echo `date` >> /home/ceiec/nms/nmsclient/nc_logs/ttt.log


base_dir="/home/ceiec/nms/nmsclient"
conf=$base_dir"/conf/process.list"
pid_dir=$base_dir"/temp"
myselfpid=$pid_dir"/pidcheck.pid"


diconf_dir="/home/ceiec/nms/nmsdata/nc_config"
diconf_file=`echo $0 | awk -F '/' '{print $NF}' |  awk -F '.' '{print $1}' `
file_name=$diconf_file
diconf_file=$diconf_dir"/"$diconf_file".cfg"

clog_conf=$base_dir"/conf/clog.list"

monitorstart=`stat $diconf_file | grep Modify | awk '{print $2" "$3}'`
mstimestamp=`date -d "$monitorstart" +%s%N`
remstimestamp=$((mstimestamp/1000000))
pubInfo=`cat $diconf_file | grep pubInfo | cut -d = -f 2`

mypid=$$
echo $$ > $myselfpid

#echo $conf
pdate=`date +'%Y%m%d%H%M%S'`
stat_file=$pid_dir"/$pdate"".rep"
incoming_file=$pid_dir"/$pdate"".csv"
temp_file=$pid_dir"/$pdate"".tmp"

timeStamp=`date +%s%N`
currentTimeStamp=$((timeStamp/1000000))
later15mTimeStamp=$((currentTimeStamp+checkGap*60*1000))

didata_dir=`cat $diconf_file | grep dataFileDir | cut -d = -f 2`
ditemp_dir=`cat $diconf_file | grep tempDataFileDir | cut -d = -f 2`
checkGap=`cat $diconf_file | grep checkGap | cut -d = -f 2`
dataFileDir=`cat $diconf_file | grep dataFileDir | cut -d = -f 2`

interstatus=""
perstatus=""

linenum=0
  while read pline
  do
  if [ -n "$pline" ]; then
#    echo line=$pline
    num=0 
    isclog=0
    firstc=`echo $pline | cut -c 1`
    if [ "$firstc" != "#" ]; then
        module=`echo $pline | cut -d = -f 1`
        keyword=`echo $pline | cut -d = -f 2`
#        echo $module $keyword
        clog_dir=`cat $clog_conf | grep -v "#" | grep $module | cut -d = -f 2 | cut -d , -f 1`
        clog_name=`cat $clog_conf | grep -v "#" | grep $module | cut -d = -f 2 | cut -d , -f 2`
#        echo $module : $clog_dir , $clog_name

        case $module in 
          "processcheck")
            prostatus=`ps u -P "$mypid" | grep -v grep | grep -v vim | grep -v USER`;
            num=`ps u -P "$mypid" | grep -v grep | grep -v vim | grep -v USER | wc -l`;
          ;;
          "nmsweb")
            prostatus=`ps aux | grep -E "$keyword" | grep "nms" | grep -v grep | grep -v galaxy`;
            num=`ps aux | grep -E "$keyword" | grep "nms" | grep -v grep | grep -v galaxy | wc -l`;
          ;;
          "nmsdc")
            prostatus=`ps aux | grep -E "$keyword" | grep -v grep`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | wc -l`;
          ;;
          "nmsclient")
            prostatus=`ps aux | grep -E "$keyword" | grep -v shouhu | grep -v grep`;
            num=`ps aux | grep -E "$keyword" | grep -v shouhu | grep -v grep | wc -l`;
          ;;
          "ntcsweb")
            prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v galaxy | grep -v nms`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v galaxy | grep -v nms | wc -l`;
          ;;
          "mariadb")
            prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v safe`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v safe | wc -l`;
          ;;
          "galaxyService"|"galaxyFsync"|"galaxyPush"|"galaxyStat"|"galaxyTest"|"logComplete"|"logStat"|"logTopIP"|"logTopN"|"logUV")
            prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v Daemon`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v Daemon | wc -l`;
          ;;
          "pzffff"|"pzffhj"|"paffkeep")
            prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
          ;;
          "dkAppBehavior"|"dkAppSSL"|"dkHdLdp"|"dkHdNtba"|"dkHdStrategy"|"dkQx"|"dkLogProcess")
            prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
          ;;
		  "Tensor"|"Redis"|"panguValve")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "redis")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "mrzcpd"|"Sapp"|"Oam")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "maskey2.0")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "rssbMaskey"|"fragIndexCluster"|"castleBlack"|"eastwatch"|"platformvideo"|"platformaudio"|"platformimage"|"platformvoip")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "avanalyser"|"pic"|"voip"|"audio"|"video"|"fragcheck"|"blacklist")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "dkLdp"|"dkZeusLogclct"|"dkSappClean"|"dkZeusNtbapre"|"dkSappNtba")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "zookeeper"|"Kafka"|"Strom"|"clickhouse"|"Hades")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "consul"|"telegraf"|"infludb"|"Grafana")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "mrzcpd"|"Sapp"|"Torches")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "irAccess"|"irFoward")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "IPDiscovery")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "Tfe"|"kni")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "Minio"|"minioEventsPretreat"|"minioDeteteClient")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
		  "certStore")
			prostatus=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh`;
            num=`ps aux | grep -E "$keyword" | grep -v grep | grep -v sh | wc -l`;
		  ;;
          *)
          ;;
        esac
        pidfile=$pid_dir"/"$module".pid";
#        echo HERE num=$num 
#        echo $prostatus
#        echo  "HERE?  "
        if [ $num = 1 ]; then
          pid=`echo $prostatus | awk '{print $2}'` ;
          echo $pid > $pidfile
          pstatistics=`ps -eo pid,stat,priority,pcpu,pmem,lstart | grep $pid`
          #pcpu=`echo $pstatistics | awk '{print $4}'`
          pcpu=`top -c -b -p $pid -n 1 | tail -1 | grep $pid | awk '{print $9}'`
          pmem=`echo $pstatistics | awk '{print $5}'`
          prostatus=`echo $pstatistics | awk '{print $2}'`
          propri=`echo $pstatistics | awk '{print $3}'`
          lstart=`echo $pstatistics | awk '{for (i=6 ;i<=NF;i++) printf $i " "; printf "\n" }'`
          linenum=$((linenum+1))
#          echo $module $clog_dir $clog_name
          if [ -n "$clog_dir" ]; then
            if [ -n "$clog_name" ]; then
              if [ -d $clog_dir ]; then
#                echo have filename $clog_dir $clog_name
                case $module in
                "pzffff")
                  if [ "$clog_name" = "cc_recv" ]; then
                    isclog=`find $clog_dir -maxdepth 3 -mmin -$checkGap -name "$clog_name*" | wc -l`
                    if [ "$isclog" = "0" ]; then
                      isclog="--!!! $clog_name LOG FILES MISSED IN $checkGap MINUTE ! PLEASE CHECK ON SERVER!!!--"
                      interstatus=$interstatus"Bad finding on $module $clog_name behavior. | "
                    else
                      isclog="OK"
                    fi
                  fi
                ;;
                "pzffhj")
                  isclog=`find $clog_dir -maxdepth 3 -mmin -$checkGap -name "$clog_name*" | wc -l`
                  if [ "$isclog" = "0" ]; then
                    isclog="OK"
                  else
                    isclog="--!!! $module $clog_name IN $checkGap MINUTE ! PLEASE CHECK ON SERVER!!!--"
                    interstatus=$interstatus"Bad finding on $module $clog_name behavior. | "
                  fi
                ;;
                "pzffkeep")
                  isclog="null"
                ;;
                *)
                  isclog=`find $clog_dir -mmin -$checkGap -name "$clog_name*" | wc -l`
                  if [ $isclog -gt 0 ]; then
                    interstatus=$interstatus"Bad finding on $module $clog_name behavior. | "
                  fi
                  isclog="$isclog critical log files are modified in $checkGap minutes."
                ;;
                esac
              else
#                echo $module log not found
                isclog="Log path not found: $clog_dir"
                interstatus=$interstatus"Log path wrong. | "
              fi
            else
              if [ -d $clog_dir ]; then
#                echo no filename $clog_dir
                isclog=`find $clog_dir -maxdepth 1 -mmin -$checkGap | wc -l`
                isclog="$isclog critical log files are modified in $checkGap minutes."
              fi
            fi
          else
            isclog="null"
          fi
          echo -e "$module,$pid,$pcpu,$pmem,$prostatus,$propri,$lstart,$isclog," >> $stat_file
        else
          if [ "$module" = "pzffc2res" ]; then
            isclog=`find $clog_dir -mmin -$checkGap -name "$clog_name*" | wc -l`
            if [ $isclog -gt 0 ]; then
              pzffffline=`grep pzffff $stat_file`
              if [ -n "$pzffffline" ]; then
                sed -i '/pzffff/d' $stat_file
                echo $pzffffline" | RESTART log is modified in $checkGap minites." >> $stat_file
              fi
            fi
          else
            pid=""; pstatistics="--"; pcpu=""; pmem=""; prostatus="NotFound"; propri=""; lstart=""; linenum=$((linenum+1));
            isclog="null"
            interstatus=$interstatus"$module miss something this interval. | "
            echo -e "$module,$pid,$pcpu,$pmem,$prostatus,$propri,$lstart,$isclog," >> $stat_file
            if [ -f $pidfile ]; then
              rm $pidfile
            fi
          fi
        fi
    fi
  fi
  done < $conf
#  echo "$pubInfo,$remstimestamp,0,$currentTimeStamp,1,$later15mTimeStamp,1,\"$interstatus\",\"$perstatus\"" > $incoming_file
#  echo "details,$linenum" >> $incoming_file
#  cat $stat_file >> $incoming_file

  echo "0,1,\"$interstatus\"" > $temp_file
  echo "details,$linenum" >> $temp_file
  cat $stat_file >> $temp_file
  mv $temp_file $ditemp_dir
  rm -rf $stat_file
