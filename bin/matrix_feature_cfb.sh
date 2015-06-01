bin=/etc/azkaban/neo-str-new/bin
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
. $bin/neo-config.sh


version=$1
d=$2
hour=$3
input=/data/userProfile/neo_dump/$version/UserGroupProfile
output=hdfs://nameservice1/user/hive/warehouse/matrix.db/cfb_doc_user/p_day=$d/p_hour=$hour

echo "HDFS INPUT" $input
echo "HDFS OUTPUT" $output

res_dir=$(cd $bin/../conf; pwd)
java -classpath $bin:$CLASSPATH $JAVA_OPTS yidian.data.neo.mr.GenerateFeatureJob -Dhdfs.input=$input -Doutput=$output -Dfeature.types=DocGender,DocUserProfileSegment -Dtmpfiles=file:$res_dir/user_dim_vocab,file:$res_dir/user_facet_vocab -Dmatrix=UserGroupProfile "$@"
