#!/bin/sh
set -e

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. $bin/neo-config.sh

#JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
    shift
fi

version=$1
dump_date=$2
sql_file=$3

input=/data/userProfile/neo_str/delta/$version/DocChannel
java $JAVA_OPTS -classpath $bin:$CLASSPATH yidian.data.neo.tool.DumpMatrix -Ddump.output=$sql_file -Ddump.date=$dump_date -Ddump.input.type=hdfs -Ddump.input=$input
