#!/bin/bash

BITBAKE_RETRY_COUNT=4
SCRIPT_DIR=$(cd $(dirname $0); pwd)

cd /home/yocto

#
# set up the development environment
#
. ./environment-setup-x86_64-wrlinuxsdk-linux
. ./oe-init-build-env build

touch conf/sanity.conf

#
# generating SBOM files
#
bitbake-layers add ../meta-wr-sbom

#
# edit local.conf
#
sed -ie "s/BB_NO_NETWORK ?= '1'/BB_NO_NETWORK ?= '0'/" conf/local.conf

echo 'IMAGE_INSTALL:append = " \
  avahi-daemon \
  usbutils \
"' >> conf/local.conf

# hostname
echo 'hostname_pn-base-files = "wrlinux"' >> conf/local.conf

#
# bitbake
#
for i in $(seq ${BITBAKE_RETRY_COUNT}) ; do \
  bitbake wrlinux-image-small && \
  bitbake wrlinux-image-small -c populate_sdk && \
  break
  if [ $i -eq ${BITBAKE_RETRY_COUNT} ] ; then exit 1 ; fi
  sleep 1
done

#
# deploy
#
mkdir -p ${SCRIPT_DIR}/${DEST_DIR}/images/${WRL_MACHINE}

for file in $(ls -l /home/yocto/build/tmp-glibc/deploy/images/${WRL_MACHINE} | grep '\->' | awk '{print $9}')
do
  cp /home/yocto/build/tmp-glibc/deploy/images/${WRL_MACHINE}/${file} ${SCRIPT_DIR}/${DEST_DIR}/images/${WRL_MACHINE}
done

cp -r /home/yocto/build/tmp-glibc/deploy/sdk ${SCRIPT_DIR}/${DEST_DIR}/sdk
