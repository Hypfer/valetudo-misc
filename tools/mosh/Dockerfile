ARG HOST_ARCH=i686
ARG TARGET_TRIPLE=armv7l-linux-musleabihf

FROM muslcc/$HOST_ARCH:$TARGET_TRIPLE

ARG VERSION=1.4.0
ARG TARGET_ARCH=armv7l-linux

USER root:root

WORKDIR /root/

RUN apk add --no-cache build-base ncurses-dev ncurses-libs python3 autoconf automake linux-headers git

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

RUN tar xf ./ncurses.tar.gz

WORKDIR /root/ncurses/ncurses-6.3/

RUN ./configure --with-normal --host=${TARGET_ARCH} --with-terminfo-dirs="/etc/terminfo:/usr/share/terminfo:/lib/terminfo:/usr/lib/terminfo"  --without-tests --without-ada

RUN make -j4

ENV CFLAGS="-I/root/ncurses/ncurses-6.3/include -I/root/deps/usr/include/ $CFLAGS"
ENV CPPFLAGS="-I/root/ncurses/ncurses-6.3/include -I/root/deps/usr/include/ $CFLAGS"
ENV LDFLAGS="-L/root/ncurses/ncurses-6.3/lib -L/root/deps/lib/ -L/root/deps/usr/lib/ $LDFLAGS"

WORKDIR /root/mosh

ADD "https://mosh.org/mosh-${VERSION}.tar.gz" ./mosh.tar.gz

RUN tar xf ./mosh.tar.gz

WORKDIR /root/mosh/mosh-${VERSION}

ENV ARM_DEPS=/root/deps/

RUN mkdir -p $ARM_DEPS/etc/apk/

RUN cp /etc/apk/repositories $ARM_DEPS/etc/apk/

# *target* side libraries
# use nettle instead of openssl to save space
RUN apk -p $ARM_DEPS --allow-untrusted --arch armv7 add --initdb nettle-dev nettle-static protobuf-dev zlib-dev zlib-static

# *host* side protoc, needed during compilation
RUN apk add --no-cache protoc

# adjust PKG_CONFIG so it *does not* look up *host side* stuff
ENV PKG_CONFIG_SYSROOT_DIR=${ARM_DEPS}
ENV PKG_CONFIG_LIBDIR=${ARM_DEPS}/usr/lib/pkgconfig
ENV PKG_CONFIG_PATH=

# GC sections: Saves around 400 KB (1.4 MB --> 1.0 MB)
ENV CFLAGS="$CFLAGS -static -Os -ffunction-sections -fdata-sections"
ENV CPPFLAGS="$CPPFLAGS -static -Os -ffunction-sections -fdata-sections"
ENV LDFLAGS="$LDFLAGS -static -Os -Wl,--gc-sections"

# not needed, unless we want to adjust configure.ac
# RUN ./autogen.sh

RUN ./configure --disable-client --enable-static-libraries  --host=${TARGET_ARCH} --without-utempter --with-ncurses --without-ncursesw --disable-hardening --with-crypto-library=nettle --with-curses=/root/ncurses/ncurses-6.3/

# fix bug (?) in mosh build env: If pkg-config is not available, the generated config.h is wrong
RUN sed -i.bak -e '/HAVE_CURSES_H/ a#define HAVE_CURSES_H 1' src/include/config.h

# less drastic option: Only in mosh-server Makefile
# (alt: Remove in configure.ac and rerun autogen.sh)
# For some reason, the presence of -Wl,-Bdynamic as trailing argument in the
# Make link recipe makes the executable a dynamically-linked executable.
# get rid of these altogether.
RUN sed -i.bak -e 's|-Wl,-Bdynamic||g' ./src/frontend/Makefile

RUN make -j4

RUN /bin/strip ./src/frontend/mosh-server

# output checking if it's a statically linked executable.
#RUN file ./src/frontend/mosh-server

# #RUN upx --brute ./src/frontend/mosh-server