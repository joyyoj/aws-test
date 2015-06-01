#!/bin/sh

PIDFILE=./neo-update.pid
SERVICE_CMD='java -classpath $CLASSPATH $JAVA_OPTS yidian.data.neo.MatrixUpdateServer $@'

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
        if [[ $1 == "debug" ]]; then
            JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
            shift
        fi
        if java -classpath $CLASSPATH $JAVA_OPTS yidian.data.neo.MatrixUpdateServer $@ >log/counter.log 2>&1 &
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
                   if kill `cat $PIDFILE`
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
                start
        ;;
         stop)
            stop
        ;;
         restart)
            restart
        ;;
         *)
            echo "Usage: $SCRIPTNAME {start|stop|restart}" >&2
        exit 1
        ;;
esac
exit 0
