#!/bin/sh
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. $bin/neo-config.sh


if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8002"
    shift
fi

version=$1
base=20150521

#24 hours
input=/data/userProfile/neo_str/delta/201505*/UidDoc/*
echo "begin to sort"
MR_OPTS=""
#:/opt/cloudera/parcels/CDH/lib/hadoop/client-0.20/*
java -classpath $bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.DeltasMerger -Dhdfs.input=$input -Dmerge.version.target=$version -Dscheduler.matrix.list=UidDoc -Dmerge.version.base=$base -Dmerge.version.delta=$version -Dmapreduce.reduce.memory.mb=2500 -Dmapred.reduce.child.java.opts="-Xmx2200m -XX:+UseG1GC" 
