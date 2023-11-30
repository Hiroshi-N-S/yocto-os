FROM ubuntu:jammy-20231004

ENV http_proxy=
ENV https_proxy=
ENV no_proxy=

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux ;\
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
      update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 ;\
      # add yocto user.
      useradd -m -s /usr/bin/bash yocto ;\
      # add yocto to sudoers.
      echo 'yocto ALL=(ALL:ALL) NOPASSWD:ALL' >> yocto ;\
      mkdir -p /etc/sudoers.d ;\
      mv yocto /etc/sudoers.d

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

USER yocto
WORKDIR /home/yocto
