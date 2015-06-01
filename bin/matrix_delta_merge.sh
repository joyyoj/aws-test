#!/bin/sh
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. $bin/neo-config.sh


if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8002"
    shift
fi

version=$1
base=$2

#24 hours
input=/data/userProfile/neo_str/delta/${version}0*/UidDoc/*,/data/userProfile/neo_str/delta/${version}1*/UidDoc/*,/data/userProfile/neo_str/delta/${version}2*/UidDoc/*
#input=/data/userProfile/neo_str/full/20150300/UidDoc/*
echo "begin to sort"
MR_OPTS=""
#:/opt/cloudera/parcels/CDH/lib/hadoop/client-0.20/*
java -classpath $bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.DeltasMerger -Dhdfs.input=$input -Dmerge.version.target=$version -Dmerge.matrix.list=UidDoc -Dmerge.version.base=$base -Dmerge.version.delta=$version -Dmapreduce.reduce.memory.mb=1300 -Dmapred.reduce.child.java.opts="-Xmx1100m -XX:+UseG1GC" 
