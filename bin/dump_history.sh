#!/bin/sh
set -e

neo=/etc/azkaban/neo
bin=/etc/azkaban/neo/bin
export CLASSPATH=.
. $bin/neo-config.sh

if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
    shift
fi

day=$1
start_date=$2
end_date=$3
sql_file=$4

#input=/data/userProfile/neo/delta/$version/DocChannel
java -classpath $bin:$CLASSPATH yidian.data.neo.cli.DumpMatrixColumnToMysql -Ddump.output=$sql_file -Ddump.date=$day -Ddump.date.start=$start_date -Ddump.date.end=$end_date -Ddump.input.type=hbase -Ddump.feature.filter="mt^^*^^*" -Dprofile.server.host=10.111.0.143
