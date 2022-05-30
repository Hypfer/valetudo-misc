ARG HOST_ARCH=i686
ARG TARGET_TRIPLE=armv7l-linux-musleabihf

FROM muslcc/$HOST_ARCH:$TARGET_TRIPLE

ARG VERSION=DROPBEAR_2022.82
ARG TARGET_ARCH=armv7l-linux

USER root:root

WORKDIR /root/

RUN apk add --no-cache build-base linux-headers git upx

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


RUN git clone https://github.com/mkj/dropbear

WORKDIR /root/dropbear/

RUN git --work-tree . reset --hard $VERSION

COPY res/localoptions.h localoptions.h
COPY res/unsafe_permissions.patch unsafe_permissions.patch

RUN patch -p1 < unsafe_permissions.patch --ignore-whitespace

RUN ./configure --host=${TARGET_ARCH} --enable-static --disable-pam --enable-openpty --disable-lastlog --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx --disable-loginfunc --disable-pututline --disable-pututxline --disable-zlib --enable-bundled-libtom

RUN make -j4 PROGRAMS="dropbear dbclient scp"


RUN /bin/strip /root/dropbear/dropbear /root/dropbear/dbclient /root/dropbear/scp
#RUN /bin/strip /root/dropbear/dropbearmulti



#RUN upx --brute /root/htop/htop-${VERSION}/htop