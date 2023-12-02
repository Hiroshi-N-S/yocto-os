#!/bin/bash

# wrlinux image
cat <<EOF >>wrlinux-rootfs.dockerfile
FROM scratch
ADD ${WRL_IMAGE}-${WRL_MACHINE}.tar.bz2 /
CMD ["/bin/sh"]
EOF

cat wrlinux-rootfs.dockerfile

buildctl-daemonless.sh \
  build \
  --frontend \
  dockerfile.v0 \
  --local \
  context=. \
  --local \
  dockerfile=. \
  --opt \
  filename=wrlinux-rootfs.dockerfile \
  --output \
  type=image,name=mysticstorage.local:8443/wrlinux/rootfs:${WRL_IMAGE_TAG},registry.insecure=false,push=true

# wrlinux sdk image
cat <<EOF >>wrlinux-sdk.dockerfile
FROM mysticstorage.local:8443/wrlinux/host:10_23
ENV WRL_SDK_DIR=/opt/windriver
COPY ${WRL_SDK}.sh /opt/sdk/sh
RUN set -eux ;\
      # make entrypoint.sh
      echo '#!/bin/bash' >> entrypoint.sh ;\
      echo '# install wrlinux sdk' >> entrypoint.sh ;\
      echo 'if [ ! -d ${WRL_SDK_DIR} ]; then' >> entrypoint.sh ;\
      echo '  sudo sh /opt/sdk.sh -y -d ${WRL_SDK_DIR}' >> entrypoint.sh ;\
      echo 'fi' >> entrypoint.sh ;\
      echo '# setup sdk environment' >> entrypoint.sh ;\
      echo '. ${WRL_SDK_DIR}/environment-setup-corei7-64-wrs-linux' >> entrypoint.sh ;\
      echo 'exec "$@"' >> entrypoint.sh ;\
      chmod a+x entrypoint.sh

ENTRYPOINT ["/home/yocto/entrypoint.sh"]
CMD ["/bin/sh"]
EOF

cat wrlinux-sdk.dockerfile

buildctl-daemonless.sh \
  build \
  --frontend \
  dockerfile.v0 \
  --local \
  context=. \
  --local \
  dockerfile=. \
  --opt \
  filename=wrlinux-sdk.dockerfile \
  --output \
  type=image,name=mysticstorage.local:8443/wrlinux/sdk:${WRL_IMAGE_TAG},registry.insecure=false,push=false
