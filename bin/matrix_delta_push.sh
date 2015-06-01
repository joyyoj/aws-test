#!/bin/sh
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. $bin/neo-config.sh

if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
    shift
fi

day=$1
hour=$2
#dayI=$(date -d ${day} "+%Y%m%d")
version=24
baseVersion=0

merge_type=DELTA

input=/user/services/push_notification/push_log_hourly/$day/$hour/*

#MR_OPTS="-Dmapred.job.queue.name=realtime -Dmapreduce.map.memory.mb=1048 -Dmapreduce.reduce.memory.mb=3096 -Dmapreduce.map.maxattempts=4 -Dmapreduce.map.cpu.vcores=1 -Dmapreduce.reduce.cpu.vcores -Dmapreduce.reduce.maxattempts=4 -Dmapreduce.map.speculative=false -Dmapreduce.reduce.speculative=false -Dmapreduce.job.priority=VERY_HIGH"
#-Dmatrix.storage.root.path=/data/userProfile/neo/hourly 

java -classpath $bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.CommitHadoopJob -Dhdfs.input=$input -Dversion=$version -Dmatrix.version.base=$baseVersion -Dinput.type=hdfs -Dmapreduce.job.reduces=17 -Dmerge.type=$merge_type -Dmapreduce.reduce.memory.mb=1200 -Dmapred.reduce.child.java.opts=-Xmx1100m -Dscheduler.matrix.list=UidDoc,DocChannel,UserGroupProfile -Dmapreduce.map.speculative=false -Dmapreduce.input.fileinputformat.split.minsize=69496729 -Devent.emit.batch.size=5000
