#!/bin/sh
FWD=`dirname "$0"`
FWD=`cd "$FWD/.."; pwd`
cd $FWD
if [[ $1 == "dist" ]]; then
    echo "mvn package and copy dependencies"
    mvn package deploy
    mvn dependency:copy-dependencies
    cp -r update/target/dependency/* dist/lib
fi

mkdir -p dist/lib
cp profile-meta/target/profile-meta-1.0.0.jar dist/lib
cp common/target/common-1.0.0.jar dist/lib
cp update/target/update-1.0.0.jar dist/lib
cp -r bin/ dist/bin
cp -r conf/* dist/conf
