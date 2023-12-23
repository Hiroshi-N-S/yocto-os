FROM mysticstorage.local:8443/wrlinux/host:jammy-20231004

ENV WRL_MAJOR=10
ENV WRL_MINOR=30
ENV WRL_BASE=23
ENV WRL_UPDATE=3
ENV WRL_DISTRO=wrlinux
ENV WRL_MACHINE=bcm-2xxx-rpi4
ENV WRL_SDK_HOSTARCH=x86_64

ENV WRL_REPO_URL=https://github.com/WindRiverLinux${WRL_BASE}/wrlinux-x
ENV WRL_SBOM_URL=https://github.com/Wind-River/meta-wr-sbom.git

ENV WRL_BRANCH=WRLINUX_${WRL_MAJOR}_${WRL_BASE}_BASE_UPDATE000${WRL_UPDATE}
ENV WRL_IMAGE=wrlinux-image-small
ENV WRL_IMAGE_TAG=${WRL_MAJOR}_${WRL_BASE}_base_update000${WRL_UPDATE}_${WRL_DISTRO}_${WRL_MACHINE}
ENV WRL_SDK=${WRL_DISTRO}-${WRL_MAJOR}.${WRL_BASE}.${WRL_MINOR}.${WRL_UPDATE}-glibc-${WRL_SDK_HOSTARCH}-${WRL_IMAGE}-sdk

COPY wrlinux-base.exp /home/yocto/wrlinux-base.exp

RUN set -eux ;\
      # make setup-environments.sh
      echo '#!/bin/bash'                              >> setup-environments.sh ;\
      echo "export WRL_BASE=${WRL_BASE}"              >> setup-environments.sh ;\
      echo "export WRL_UPDATE=${WRL_UPDATE}"          >> setup-environments.sh ;\
      echo "export WRL_DISTRO=${WRL_DISTRO}"          >> setup-environments.sh ;\
      echo "export WRL_MACHINE=${WRL_MACHINE}"        >> setup-environments.sh ;\
      echo "export WRL_BRANCH=${WRL_BRANCH}"          >> setup-environments.sh ;\
      echo "export WRL_IMAGE=${WRL_IMAGE}"            >> setup-environments.sh ;\
      echo "export WRL_IMAGE_TAG=${WRL_IMAGE_TAG}"    >> setup-environments.sh ;\
      echo "export WRL_SDK=${WRL_SDK}"                >> setup-environments.sh ;\
      echo 'export DEST_DIR=deploy'                   >> setup-environments.sh ;\
      echo 'mkdir -p $DEST_DIR'                       >> setup-environments.sh ;\
      # run setup.sh to define your project configuration
      expect wrlinux-base.exp ;\
      rm wrlinux-base.exp
