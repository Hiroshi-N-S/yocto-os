FROM ubuntu:jammy-20231004

ENV WRL_BRANCH=WRLINUX_10_22_BASE
ENV WRL_REPO_URL=https://github.com/WindRiverLinux22/wrlinux-x
ENV WRL_SBOM_URL=https://github.com/Wind-River/meta-wr-sbom.git

ENV http_proxy=
ENV https_proxy=

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux ;\
      useradd -m -s /usr/bin/bash yocto ;\
      # proxy config for apt
      echo 'Acquire::http::Proxy "$http_proxy";' >>apt-proxy.conf ;\
      echo 'Acquire::https::Proxy "$https_proxy";' >>apt-proxy.conf ;\
      mkdir -p /etc/apt/apt.conf.d ;\
      mv apt-proxy.conf /etc/apt/apt.conf.d/apt-proxy.conf ;\
      apt update && apt install -y \
        expect \
        # Necessary Linux Host System Libraries and Executables
        gawk \
        wget \
        git \
        diffstat \
        unzip \
        texinfo \
        gcc \
        build-essential \
        chrpath \
        socat \
        cpio \
        python3 \
        python3-pip \
        python3-pexpect \
        xz-utils \
        debianutils \
        iputils-ping \
        python3-git \
        python3-jinja2 \
        libegl1-mesa \
        libsdl1.2-dev \
        python3-subunit \
        mesa-common-dev \
        zstd \
        liblz4-tool \
        file \
        locales \
      ;\
      dpkg-reconfigure -f noninteractive locales ;\
      locale-gen en_US.UTF-8 ;\
      update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

USER yocto
WORKDIR /home/yocto
ADD wrlinux-base.exp /home/yocto/wrlinux-base.exp

RUN set -eux ;\
      expect wrlinux-base.exp ;\
      rm wrlinux-base.exp
