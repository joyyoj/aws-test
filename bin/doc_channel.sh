#!/bin/sh
set -e

neo=/etc/azkaban/neo-str
bin=/etc/azkaban/neo-str/bin

daym=2015-02-10
hour=23
#prev_hour=21
dayI=$(date -d ${daym} "+%Y%m%d")

version=$dayI$hour 
#baseVersion=$dayI${prev_hour} 

input=/data/userProfile/neo_str/delta/$version/DocChannel
#sh $bin/calf_commit.sh 2014-12-18 08 $baseVersion DELTA 
sql_file=fact_doc_quality.sql

echo $CLASSPATH 
#sh $neo/dump_column.sh  
sh $bin/dump_sql.sh $version 201501062242 $sql_file
