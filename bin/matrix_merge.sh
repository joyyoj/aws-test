#!/bin/sh
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. $bin/neo-config.sh

if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
    CLASSPATH=$HIVE_LIB/hive-exec-0.12.0-cdh5.1.0.jar:$HIVE_LIB/libfb303-0.9.0.jar:$HIVE_LIB/hive-metastore-0.12.0-cdh5.1.0.jar:/opt/cloudera/parcels/CDH/lib/hadoop-hdfs/*:/opt/cloudera/parcels/CDH/lib/hadoop-yarn/*:/opt/cloudera/parcels/CDH/lib/hadoop/*:/opt/cloudera/parcels/CDH/lib/hadoop/client-0.20/*:/opt/cloudera/parcels/CDH/lib/hadoop-httpfs/webapps/webhdfs/WEB-INF/lib/:$CLASSPATH
    shift
fi

#MR_OPTS="-Dmapreduce.map.memory.mb=3000"
#-Dinput=$input -Doutput=$output -Dversion=$version

version_delta=$1
version_target=$1
version_base=$2

java -classpath $bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.MatrixDataStorageMerger -Dmapreduce.job.priority=HIGH $MR_OPTS -Dmerge.version.base=$version_base -Dmerge.version.delta=$version_delta -Dmerge.version.target=$version_target -Dmapreduce.map.memory.mb=1600 -Dmapred.map.child.java.opts="-Xmx1450m -XX:+UseG1GC" 
