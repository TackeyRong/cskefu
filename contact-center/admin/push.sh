#! /bin/bash 
###########################################
#
###########################################

# constants
baseDir=$(cd `dirname "$0"`;pwd)
appHome=$baseDir/..
registryPrefix=registry.cn-guangzhou.aliyuncs.com/
imagename=private-wen/contact-center

# functions

# main 
[ -z "${BASH_SOURCE[0]}" -o "${BASH_SOURCE[0]}" = "$0" ] || return
# build
cd $appHome
PACKAGE_VERSION=`git rev-parse --short HEAD`

docker push $registryPrefix$imagename:$PACKAGE_VERSION
docker push $registryPrefix$imagename:develop

echo "$PACKAGE_VERSION"
