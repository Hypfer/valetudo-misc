ARG HOST_ARCH=i686
ARG TARGET_TRIPLE=armv7l-linux-musleabihf

FROM muslcc/$HOST_ARCH:$TARGET_TRIPLE

ARG VERSION=v2.38
ARG TARGET_ARCH=armv7l-linux

USER root:root

WORKDIR /root/

RUN apk add --no-cache build-base linux-headers git upx autoconf automake libtool gettext bison gettext-dev pkgconfig

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


RUN git clone https://github.com/mhei/mmc-utils

WORKDIR /root/mmc-utils/

ENV CFLAGS="$CFLAGS -static -Os"
ENV SUID_CFLAGS="$SUID_CFLAGS -static -Os"
ENV SUID_LDFLAGS="$SUID_LDFLAGS -static -Os"
ENV CPPFLAGS="$CPPFLAGS -static -Os"
ENV LDFLAGS="$LDFLAGS -static -Os"


RUN make -j4 LDFLAGS="--static"


RUN find -executable -type f -maxdepth 1 -exec /bin/strip {} \;

#RUN /bin/strip /root/util-linux/hexdump



#RUN upx --brute /root/htop/htop-${VERSION}/htop