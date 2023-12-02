FROM mysticstorage.local:8443/wrlinux/host:10_23

ENV WRL_MAJOR=10
ENV WRL_MINOR=30
ENV WRL_BASE=23
ENV WRL_BRANCH=WRLINUX_${WRL_MAJOR}_${WRL_BASE}_BASE
ENV WRL_REPO_URL=https://github.com/WindRiverLinux${WRL_BASE}/wrlinux-x
ENV WRL_SBOM_URL=https://github.com/Wind-River/meta-wr-sbom.git

COPY wrlinux-base.exp /home/yocto/wrlinux-base.exp

RUN set -eux ;\
      expect wrlinux-base.exp ;\
      rm wrlinux-base.exp
