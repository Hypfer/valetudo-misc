ARG HOST_ARCH=i686
ARG TARGET_TRIPLE=armv7l-linux-musleabihf

FROM muslcc/$HOST_ARCH:$TARGET_TRIPLE

ARG VERSION=6.3
ARG TARGET_ARCH=armv7l-linux

USER root:root

WORKDIR /root/

RUN apk add --no-cache build-base ncurses-dev ncurses-libs python3 autoconf automake linux-headers git upx texinfo

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

RUN ./configure --with-normal --host=${TARGET_ARCH} --with-terminfo-dirs="/etc/terminfo:/usr/share/terminfo:/lib/terminfo:/usr/lib/terminfo"  --without-tests --without-ada --enable-widec

RUN make -j4

ENV CFLAGS="-I/root/ncurses/ncurses-6.3/include $CFLAGS"
ENV CPPFLAGS="-I/root/ncurses/ncurses-6.3/include $CFLAGS"
ENV LDFLAGS="-L/root/ncurses/ncurses-6.3/lib $LDFLAGS"


WORKDIR /root/nano/

ADD "https://www.nano-editor.org/dist/v6/nano-${VERSION}.tar.xz" /root/nano/nano.tar.xz

RUN tar xf ./nano.tar.xz

WORKDIR /root/nano/nano-${VERSION}

ENV CFLAGS="$CFLAGS -Os -Wall --static"
ENV CPPFLAGS="$CPPFLAGS -Os -Wall --static"

RUN ./configure --host=${TARGET_ARCH} --disable-extra --disable-help --disable-histories --disable-mouse --disable-nanorc --disable-speller --enable-tiny
#RUN ./configure --host=${TARGET_ARCH} --disable-extra --disable-help --disable-histories --disable-mouse --disable-nanorc --disable-speller 

RUN make -j4

RUN /bin/strip /root/nano/nano-${VERSION}/src/nano

RUN file /root/nano/nano-${VERSION}/src/nano
