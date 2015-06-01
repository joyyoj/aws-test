#!/bin/sh
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. $bin/neo-config.sh

if [[ $1 == "debug" ]]; then
    JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8002"
    shift
fi

NEO_CLASSPATH=.
# add libs to CLASSPATH.
for f in "$NEO_HOME"/lib/*.jar; do
  #fname=`basename $f`
  NEO_CLASSPATH="$NEO_CLASSPATH:$f";
done
#NEO_CLASSPATH=$NEO_HOME/lib/jetty-all-9.2.3.v20140905.jar:$NEO_HOME/lib/neo-update-assembly-1.0.0.jar:$NEO_HOME/lib/servlet-api-2.5.jar
CLASSPATH=$NEO_HOME/conf:$HADOOP_CONF_DIR:$HIVE_CONF_DIR:$NEO_CLASSPATH:/opt/cloudera/parcels/CDH/lib/hadoop/client/*
echo $CLASSPATH
java -classpath $CLASSPATH $JAVA_OPTS yidian.data.neo.services.MatrixDebugServer -Dmatrix.storage.root.path=/data/userProfile/neo_str -Dthrift.port=9901 -Dhttp.port=8080 "$@"
