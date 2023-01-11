ARG HOST_ARCH=i686
ARG TARGET_TRIPLE=armv7l-linux-musleabihf

FROM muslcc/$HOST_ARCH:$TARGET_TRIPLE

ARG VERSION=4.5.1
ARG TARGET_ARCH=armv7l-linux

USER root:root

WORKDIR /root/

RUN apk add --no-cache build-base linux-headers git upx autoconf automake gettext gettext-dev libtool

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

ENV CFLAGS="$CFLAGS -Os -marm -mcpu=cortex-a7 -static"
ENV SUID_CFLAGS="$SUID_CFLAGS -static -Os"
ENV SUID_LDFLAGS="$SUID_LDFLAGS -static -Os"
ENV CPPFLAGS="$CPPFLAGS -static -Os"
ENV LDFLAGS="$LDFLAGS -static -Os"
#ENV CHOST=arm

RUN git clone https://github.com/madler/zlib

WORKDIR /root/zlib/

RUN git --work-tree . reset --hard v1.2.13

RUN ./configure --static --prefix=/deps

RUN make -j4

RUN make install


ENV CFLAGS="-I/deps/include $CFLAGS"
ENV CPPFLAGS="-I/deps/include $CFLAGS"
ENV LDFLAGS="-L/deps/lib $LDFLAGS"

WORKDIR /root/

RUN git clone https://git.tukaani.org/xz.git

WORKDIR /root/xz/

RUN git --work-tree . reset --hard v5.4.0

RUN ./autogen.sh || :

RUN ./configure --host=${TARGET_ARCH} --prefix=/deps

RUN make -j4

RUN make install


WORKDIR /root/

RUN git clone https://github.com/plougher/squashfs-tools

WORKDIR /root/squashfs-tools/

RUN git --work-tree . reset --hard $VERSION

WORKDIR /root/squashfs-tools/squashfs-tools

ENV TARGET_ARCH=""

RUN make -j4 GZIP_SUPPORT=1 XATTR_SUPPORT=1 XZ_SUPPORT=1 LZMA_XZ_SUPPORT=1


RUN /bin/strip /root/squashfs-tools/squashfs-tools/mksquashfs
RUN /bin/strip /root/squashfs-tools/squashfs-tools/unsquashfs



#RUN upx --brute /root/htop/htop-${VERSION}/htop