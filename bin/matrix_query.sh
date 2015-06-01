#!/bin/sh
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. $bin/neo-config.sh

if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
    shift
fi
echo $@
java -classpath $CLASSPATH $JAVA_OPTS yidian.data.neo.cli.MatrixQueryEngine "$@"
