#!/usr/bin/env bash

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

if [[ "x$NEO_HOME" == "x" ]]; then
  bin=`dirname "$0"`
  bin=`cd "$bin"; pwd`
  export NEO_HOME=`cd $bin/..; pwd`
fi

echo "NEO_HOME:" $NEO_HOME


export NEO_HOME=`cd $bin/..; pwd`

export HBASE_CONF_DIR=/etc/hbase/conf/
export HADOOP_CONF_DIR=/etc/hadoop/conf/
export HIVE_CONF_DIR=/etc/hive/conf

NEO_CLASSPATH=.
# add libs to CLASSPATH.
for f in "$NEO_HOME"/lib/*.jar; do
  #fname=`basename $f`
  NEO_CLASSPATH="$NEO_CLASSPATH:$f";
done

HADOOP_CLASSPATH=
for f in /opt/cloudera/parcels/CDH/lib/hadoop/client/*.jar; do
  fname=`basename $f`
  if [[ ${fname:0:5} != "guava" ]]; then
    HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f;
  fi
done

CLASSPATH=$NEO_HOME/conf:$HADOOP_CONF_DIR:$HIVE_CONF_DIR:$HADOOP_CLASSPATH:$NEO_CLASSPATH:$CLASSPATH

#echo "CLASSPATH="$CLASSPATH
export CLASSPATH
