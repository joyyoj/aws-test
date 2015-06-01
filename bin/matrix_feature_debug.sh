#!/bin/sh

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
. $bin/neo-config.sh


if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
    shift
fi

#MR_OPTS=""
#version=$1
#day=$2
input=/data/userProfile/neo_str/delta/2015033100/UidDoc/0
output=hdfs://nameservice1/user/hive/warehouse/matrix.db/matrix_user_feature/p_day=20150331-debug

java -classpath /opt/cloudera/parcels/CDH/lib/hadoop/client-0.20/:$bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.GenerateFeatureJob -Dhdfs.input=$input -Doutput=$output
