FROM ubuntu:20.04

LABEL maintainer = "Kevin Suhajda <kevin@nevercode.io>"

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

RUN apt-get -qqy update && \
    apt-get -qqy --no-install-recommends install \
    build-essential \
    ca-certificates \
    clang \
    curl \
    cmake \
    expect \
    gcc \
    git-core \
    lcov \
    lib32gcc1  \
    lib32stdc++6 \
    lib32z1 \
    libc6-i386  \
    libgles2-mesa-dev \
    libglu1 \
    libglu1-mesa \
    libgtk-3.0 \
    libgtk-3-dev \
    libstdc++6 \
    locales \
    maven  \
    nano \
    ninja-build \
    pkg-config \
    qemu-kvm \
    rsync \
    screen  \
    scrot \
    software-properties-common \
    supervisor \
    tmux  \
    unzip \
    wget  \
    xvfb \
    x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "en_US.UTF-8 UTF-8" > /etc/locale.gen' && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8

   
RUN useradd -m -s /bin/bash user

USER user

WORKDIR /home/user
RUN cmake --version

ENV FLUTTER_HOME /home/user/flutter
ENV FLUTTER_ROOT $FLUTTER_HOME


RUN git clone -b beta https://github.com/flutter/flutter.git ${FLUTTER_HOME}

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:/home/user/.pub-cache/bin

RUN flutter channel dev
RUN flutter upgrade
RUN flutter config --enable-linux-desktop
RUN flutter precache --linux
RUN flutter doctor

RUN pub global activate fast_flutter_driver_tool

RUN git clone https://github.com/tomaszpolanski/fast_flutter_driver.git /home/user/fast_flutter_driver
RUN cd /home/user/fast_flutter_driver/example && flutter packages get

ENV DISPLAY :0
CMD ["Xvfb", ":0", "-screen", "0", "1920x1920x24"]
