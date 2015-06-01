#!/bin/sh

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
. $bin/neo-config.sh

if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
    shift
fi

version=$1
day=$2
input=/data/userProfile/neo_str/delta/$version/UidDoc/*
output=hdfs://nameservice1/user/hive/warehouse/matrix.db/matrix_user_feature/p_day=$day

echo "HDFS INPUT" $input
echo "HDFS OUTPUT" $output
echo "param" $@
#/opt/cloudera/parcels/CDH/lib/hadoop/client-0.20/*:
java -classpath $bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.GenerateFeatureJob -Dhdfs.input=$input -Doutput=$output -Dfeature.types=ClickSkip,ClickShare,Flexetl -Dmapreduce.map.memory.mb=1800 -Dmapred.map.child.java.opts="-Xmx1500m -XX:+UseG1GC" 
