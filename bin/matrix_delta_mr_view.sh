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
dayI=$(date -d ${day} "+%Y%m%d")
version=$dayI$hour
baseVersion=$3

merge_type=FULL
if [ $# -eq 4 ]; then
    merge_type=$4
fi

input=/user/azkaban/camus/userclick/hourly/$day/$hour/*,/user/azkaban/camus/indata_str_checkedevent/hourly/$day/$hour/*

#MR_OPTS="-Dmapred.job.queue.name=realtime -Dmapreduce.map.memory.mb=1048 -Dmapreduce.reduce.memory.mb=3096 -Dmapreduce.map.maxattempts=4 -Dmapreduce.map.cpu.vcores=1 -Dmapreduce.reduce.cpu.vcores -Dmapreduce.reduce.maxattempts=4 -Dmapreduce.map.speculative=false -Dmapreduce.reduce.speculative=false -Dmapreduce.job.priority=VERY_HIGH"
#-Dmatrix.storage.root.path=/data/userProfile/neo/hourly 
matrixls=UidDoc,DocChannel
#UserGroupProfile,
java -classpath $bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.CommitHadoopJob -Dhdfs.input=$input -Dversion=$version -Dmatrix.version.base=$baseVersion -Dinput.type=hdfs -Dmapreduce.job.reduces=17 -Dmerge.type=$merge_type -Dmapreduce.reduce.memory.mb=1200 -Dmapred.reduce.child.java.opts=-Xmx1100m -Dscheduler.matrix.list=$matrixls -Dmatrix.storage.root.path=/data/userProfile/neo_str_new -Dprocess.event.views=false -Dmapreduce.map.speculative=false
