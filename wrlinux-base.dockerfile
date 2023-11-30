FROM mysticstorage.local:8443/wrlinux/host:10_23

ENV WRL_BRANCH=WRLINUX_10_22_BASE
ENV WRL_REPO_URL=https://github.com/WindRiverLinux22/wrlinux-x
ENV WRL_SBOM_URL=https://github.com/Wind-River/meta-wr-sbom.git

COPY wrlinux-base.exp /home/yocto/wrlinux-base.exp

RUN set -eux ;\
      expect wrlinux-base.exp ;\
      rm wrlinux-base.exp
