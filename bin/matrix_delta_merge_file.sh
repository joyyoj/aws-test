#!/bin/sh
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. $bin/neo-config.sh


if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8002"
    shift
fi

target=$10$2
input=$3

java -classpath $bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.DeltasMerger -Dmerge.version.target=$target -Dhdfs.input.file=$input -Dmerge.matrix.list=UidDoc -Dmapreduce.reduce.memory.mb=1300 -DmergeType=MERGE -Dmapred.reduce.child.java.opts="-Xmx1100m -XX:+UseG1GC" 
