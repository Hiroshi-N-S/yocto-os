FROM mysticstorage.local:8443/wrlinux/repo:10_23_base

ENV WRL_BASE=10_23
ENV WRL_UPDATE=0003
ENV WRL_DISTRO=wrlinux
ENV WRL_MACHINE=bcm-2xxx-rpi4
ENV WRL_BRANCH=WRLINUX_${WRL_BASE}_BASE_UPDATE${WRL_UPDATE}

ADD wrlinux-base-update.exp /home/yocto/wrlinux-base-update.exp

RUN set -eux ;\
      # make setup-environments.sh
      echo "#!/bin/bash" >> setup-environments.sh ;\
      echo "export WRL_BASE=${WRL_BASE}" >> setup-environments.sh ;\
      echo "export WRL_UPDATE=${WRL_UPDATE}" >> setup-environments.sh ;\
      echo "export WRL_DISTRO=${WRL_DISTRO}" >> setup-environments.sh ;\
      echo "export WRL_MACHINE=${WRL_MACHINE}" >> setup-environments.sh ;\
      echo "export WRL_BRANCH=WRLINUX_\${WRL_BASE}_BASE_UPDATE\${WRL_UPDATE}" >> setup-environments.sh ;\
      # echo "export WRL_IMAGE=wrlinux" >> setup-environments.sh ;\
      echo "export WRL_IMAGE_TAG=${WRL_BASE}_BASE_UPDATE${WRL_UPDATE}_${WRL_DISTRO}_${WRL_MACHINE}" >> setup-environments.sh ;\
      # echo "export =" >> setup-environments.sh ;\
      # run setup.sh to define your project configuration
      expect wrlinux-base-update.exp
