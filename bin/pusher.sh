#!/bin/sh

set -e

cwd=$(cd `dirname $0`/..; pwd)
PIDFILE=$cwd/pusher.pid.$iid

export CLASSPATH=/opt/cloudera/parcels/CDH/lib/hbase/*:/opt/cloudera/parcels/CDH/lib/hadoop/client/*:
start()
{
    if test -e $PIDFILE
    then
        echo "neo-update already running."
    else
        echo -e "Starting neo-updater"
        bin=`dirname "$0"`
        bin=`cd "$bin"; pwd`
        . $bin/neo-config.sh
	echo $CLASSPATH
	#log_dir=./log.`date +%Y%m%d-%H%M%S`
	#if [[ -z iid ]];
	log_dir=./log.$iid
	if [ ! -d $log_dir ]; then
	   mkdir $log_dir
	fi
#-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=9021 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false 
	export JAVA_OPTS="-Xms1g -Xmx5g -XX:+HeapDumpOnOutOfMemoryError -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Dyarn.app.container.log.dir=${log_dir}"
        if [[ $1 == "debug" ]]; then
            JAVA_OPTS=" -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000 $JAVA_OPTS"
            shift
	    echo $JAVA_OPTS
	    java $JAVA_OPTS -classpath $CLASSPATH yidian.data.neo.akka.PushWorker "$@" >>${log_dir}/counter.log 2>&1
        fi
        if java $JAVA_OPTS -classpath $CLASSPATH yidian.data.neo.akka.PushWorker "$@" >>${log_dir}/counter.log 2>&1 &
        then
            echo $! > $PIDFILE
            echo -e "neo-update start OK"
        else
            echo -e "neo-update start failed"
        fi
    fi
}

stop()
{
         if test -e $PIDFILE
         then
                   echo -e "Stopping neo-update"
                   if kill -9 `cat $PIDFILE`
                   then
                        echo -e "neo-update stop OK"
                   else
                        echo -e "neo-update stop faild"
                   fi
                   rm $PIDFILE
         else
                   echo -e "No neo-update running"
         fi
}

restart()
{
    echo -e "Restarting neo-update"
    stop
    start
}

case $1 in
         start)
		shift
                start "$@"
        ;;
         stop)
	 	shift
            stop
        ;;
         restart)
	 	shift
            restart "$@"
        ;;
         *)
            echo "Usage: $SCRIPTNAME {start|stop|restart}" >&2
        exit 1
        ;;
esac
exit 0
