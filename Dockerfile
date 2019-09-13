FROM ubuntu:18.04

HEALTHCHECK --start-period=30s --interval=60s --timeout=10s \
    CMD true

RUN sed -i"" "s/^# deb-src/deb-src/" /etc/apt/sources.list && \
    (grep "^deb .*debian\.org" /etc/apt/sources.list|sed "s/^deb /deb-src /") >> /etc/apt/sources.list

ARG DEBIAN_FRONTEND=noninteractive

# GnuCash dependencies
RUN apt-get update -qq && \
    apt-get build-dep -y gnucash
# Most of these have been already installed by:
# apt-get build-dep -y gnucash
# See debian/control and README.dependencies for more details
RUN apt-get install -y \
    cmake \
    googletest \
    libboost-all-dev \
    libgtk-3-dev \
    libdbd-sqlite3 \
    libdbd-pgsql \
    libdbd-mysql \
    libgwengui-gtk3-dev \
    libwebkit2gtk-4.0-dev \
    python3-dev \
    python3-gi \
    swig \
    xsltproc \
    texinfo \
    ninja-build \
    aqbanking-tools \
    locales \
    dbus-x11 \
    locales-all \
    fakeroot \
    tzdata \
    language-pack-en \
    language-pack-fr \
    language-pack-de 

# Package build dependencies
RUN apt-get install -y \
    build-essential \
    devscripts \
    lintian \
    diffutils \
    patch \
    patchutils \
    quilt \
    dput \
    sudo \
    vim \
    git \
    bash-completion \
    gpg \
    curl && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    update-locale LANG=${LANG:-en_US.UTF-8}

ENV LANG=${LANG:-en_US.UTF-8} \
    TZ=${TZ:-Etc/UTC}

RUN groupadd --system \
    --gid ${GID:-1000} \
    ubuntu

RUN useradd --system \
    --create-home \
    --home-dir /home/ubuntu \
    --shell /bin/bash \
    --uid ${UID:-1000} \
    --gid ${GID:-1000} \
    --groups sudo \
    --password "$(openssl passwd -1 ubuntu)" \
    ubuntu

USER ubuntu
WORKDIR /home/ubuntu/ppa-gnucash-xbt

CMD ./build.sh