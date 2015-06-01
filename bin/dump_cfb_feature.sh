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


version=2015040210
java $JAVA_OPTS -classpath $bin:$CLASSPATH yidian.data.neo.tool.DumpFeature -Doutput=/user/sunshangchun/dump.matrix/$version -Dhost=10.111.1.40:12000
