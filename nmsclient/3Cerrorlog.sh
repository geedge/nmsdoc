#!/bin/bash
base_dir="/home/ceiec/nms/nmsclient"
conf=$base_dir"/conf/process.list"
temp_dir=$base_dir"/temp"
temp_filelist=$temp_dir"/findfile.list"
myselfpid=$temp_dir"/cXlogrep.pid"

diconf_dir="/home/ceiec/nms/nmsdata/nc_config"
#diconf_file=$diconf_dir"/checktype100017_detection100103.cfg"
diconf_file=`echo $0 | awk -F '/' '{print $NF}' |  awk -F '.' '{print $1}' `
diconf_file=$diconf_dir"/"$diconf_file".cfg"

echo `date` $diconf_file >> /home/ceiec/nms/nmsclient/nc_logs/ttt.log

cXlog_dir="/home/ceiec/nms/nmsclient/temp/pjr/20180828_1000_ccCli/bin/log_dir"
findmaxdep=3

monitorstart=`stat $diconf_file | grep Modify | awk '{print $2" "$3}'`
mstimestamp=`date -d "$monitorstart" +%s%N`
remstimestamp=$((mstimestamp/1000000))

clogmaxsize=1024

mypid=$$
echo $$ > $myselfpid

#echo $conf
didata_dir=`cat $diconf_file | grep dataFileDir | cut -d = -f 2`
ditemp_dir=`cat $diconf_file | grep tempDataFileDir | cut -d = -f 2`
checkGap=`cat $diconf_file | grep checkGap | cut -d = -f 2`
sleeptime=$((checkGap*60))
dataFileDir=`cat $diconf_file | grep dataFileDir | cut -d = -f 2`
pubInfo=`cat $diconf_file | grep pubInfo | cut -d = -f 2`

pdate=`date +'%Y%m%d%H%M%S'`
stat_file=$temp_dir"/$pdate"".rep"
incoming_file=$temp_dir"/$pdate"".csv"
temp_file=$temp_dir"/$pdate"".tmp"

timeStamp=`date +%s%N`
currentTimeStamp=$((timeStamp/1000000))
later15mTimeStamp=$((currentTimeStamp+checkGap*60*1000))

linenum=0
  
  find $cXlog_dir -maxdepth $findmaxdep -mmin -$checkGap -name "*cc_send*" > $temp_filelist
  #find $cXlog_dir -maxdepth $findmaxdep -mmin -$sleeptime -name "*cc_send*" > $temp_filelist

  while read pline
  do
    if [ -n $pline ]; then
      filesize=`ls -l $pline | awk '{ print $5 }'`
      echo filesize=$filesize
      if [ $filesize -gt $clogmaxsize ]; then
        echo -e "$pline,,--,--,The log file is bigger than 1M. Please check it on server," >> $stat_file
        linenum=$((linenum+1))
      else
        while read logline
        do
          retime=`echo $logline | awk -F '.' '{print $1}'`
          c3ip=`echo $logline | awk '{print $3}'`
          gdevip=`echo $logline | awk '{print $4}'`
          repcontent=`echo $logline | awk '{for (i=5 ;i<=NF;i++) printf $i " | "; printf "\n" }'`
        
          linenum=$((linenum+1))
          echo -e "$pline,$retime,$c3ip,$gdevip,$repcontent," >> $stat_file
        done < $pline
      fi
    fi
  done < $temp_filelist

  echo "$pubInfo,$remstimestamp,0,$currentTimeStamp,1,$later15mTimeStamp,1,OK,OK"  > $temp_file
  if [ -f $stat_file ]; then
    linenum=`cat $stat_file | wc -l`
    echo "details,$linenum" >> $temp_file
    cat $stat_file >> $temp_file
  else
    echo "details,1" >> $temp_file
    echo -e "$pline,,--,--,No cc_send log this $checkGap minites," >> $temp_file
  fi
  mv $temp_file $ditemp_dir
#  rm -rf $stat_file

