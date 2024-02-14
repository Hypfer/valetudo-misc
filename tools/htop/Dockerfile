ARG HOST_ARCH=i686
ARG TARGET_TRIPLE=armv7l-linux-musleabihf

ARG VERSION=3.2.0

FROM muslcc/$HOST_ARCH:$TARGET_TRIPLE as builder
ARG VERSION

ARG TARGET_ARCH=armv7l-linux

USER root:root

WORKDIR /root/

RUN set -x && \
    apk add --no-cache \
        build-base \
        ncurses-dev \
        ncurses-libs \
        python3 \
        autoconf \
        automake \
        linux-headers git

# https://gitlab.alpinelinux.org/alpine/aports/-/issues/8626
ENV CFLAGS=-U_FORTIFY_SOURCE
ENV CFLAGS_host=-U_FORTIFY_SOURCE
ENV CXXFLAGS=-U_FORTIFY_SOURCE
ENV CXXFLAGS_host=-U_FORTIFY_SOURCE

ENV CC=/bin/gcc
ENV CXX=/bin/g++
ENV AR=/bin/ar
ENV NM=/bin/nm
ENV READELF=/bin/readelf
ENV STRIP=/bin/strip

ENV CC_host=/usr/bin/gcc
ENV CXX_host=/usr/bin/g++
ENV AR_host=/usr/bin/ar
ENV NM_host=/usr/bin/nm
ENV READELF_host=/usr/bin/readelf

ADD "https://invisible-mirror.net/archives/ncurses/ncurses-6.3.tar.gz" /root/ncurses/ncurses.tar.gz


WORKDIR /root/ncurses/

RUN set -x && \
    tar xf ./ncurses.tar.gz

WORKDIR /root/ncurses/ncurses-6.3/

RUN set -x && \
    ./configure \
        --with-normal \
        --host=${TARGET_ARCH} \
        --with-terminfo-dirs="/etc/terminfo:/usr/share/terminfo:/lib/terminfo:/usr/lib/terminfo"  \
        --without-tests \
        --without-adai && \
    make -j4

ENV CFLAGS="-I/root/ncurses/ncurses-6.3/include $CFLAGS"
ENV CPPFLAGS="-I/root/ncurses/ncurses-6.3/include $CFLAGS"
ENV LDFLAGS="-L/root/ncurses/ncurses-6.3/lib $LDFLAGS"

ENV HTOP_NCURSES6_CONFIG_SCRIPT=/root/ncurses/ncurses-6.3/misc/ncurses-config

WORKDIR /root/htop/

ADD "https://github.com/htop-dev/htop/archive/${VERSION}.tar.gz" /root/htop/htop.tar.gz

RUN set -x && \
    tar xf ./htop.tar.gz

WORKDIR /root/htop/htop-${VERSION}

RUN set -x && \
    ./autogen.sh && \
    ./configure --enable-static --disable-unicode --host=${TARGET_ARCH} && \
    make -j4 && \
    /bin/strip /root/htop/htop-${VERSION}/htop

FROM scratch as export
ARG VERSION
COPY --from=builder /root/htop/htop-${VERSION}/htop .
