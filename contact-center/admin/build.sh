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
TIMESTAMP=`date "+%Y%m%d.%H%M%S"`
PACKAGE_VERSION=`git rev-parse --short HEAD`
APPLICATION_CUSTOMER_ENTITY=${APPLICATION_CUSTOMER_ENTITY:-"OpenSource Community"}

$baseDir/package.sh

if [ ! $? -eq 0 ]; then
    exit 1
fi

set -x
docker build --build-arg VCS_REF=$PACKAGE_VERSION \
    --build-arg APPLICATION_BUILD_DATESTR=$TIMESTAMP \
    --build-arg APPLICATION_CUSTOMER_ENTITY="$APPLICATION_CUSTOMER_ENTITY" \
    --no-cache \
    --force-rm=true --tag $registryPrefix$imagename:$PACKAGE_VERSION .

if [ $? -eq 0 ]; then
    docker tag $registryPrefix$imagename:$PACKAGE_VERSION $registryPrefix$imagename:develop
    # 获取上2级路径目录
    PARENT_DIR="$(dirname "$(dirname "$baseDir")")"
    # 修改.env镜像标签
    sed -i "s|^\(CC_IMAGE=.*:\).*$|\1$PACKAGE_VERSION|" "$PARENT_DIR"/.env
else 
    echo "Build contact-center failure."
    exit 1
fi