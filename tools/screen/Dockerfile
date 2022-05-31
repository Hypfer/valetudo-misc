ARG HOST_ARCH=i686
ARG TARGET_TRIPLE=armv7l-linux-musleabihf

FROM muslcc/$HOST_ARCH:$TARGET_TRIPLE

ARG VERSION=v.4.9.0
ARG TARGET_ARCH=armv7l-linux

USER root:root

WORKDIR /root/

RUN apk add --no-cache build-base ncurses-dev ncurses-libs python3 autoconf automake linux-headers git upx

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

WORKDIR /root/

RUN git clone https://git.savannah.gnu.org/git/screen.git

WORKDIR /root/screen/

RUN git --work-tree . reset --hard $VERSION

WORKDIR /root/screen/src/

ENV CFLAGS="$CFLAGS -static -Os"
ENV SUID_CFLAGS="$SUID_CFLAGS -static -Os"
ENV SUID_LDFLAGS="$SUID_LDFLAGS -static -Os"
ENV CPPFLAGS="$CPPFLAGS -static -Os"
ENV LDFLAGS="$LDFLAGS -static -Os"

# https://bugs.gentoo.org/659610#c2
#RUN git revert --no-commit 2e2410a668be96bcd64afbba2fd601c237f5a68e

# https://gitlab.alpinelinux.org/alpine/aports/-/issues/3282#note_15599
#COPY res/disable_utmp.patch disable_utmp.patch
#RUN patch -p2 < disable_utmp.patch --ignore-whitespace

#COPY res/disable_password.patch disable_password.patch
#RUN patch -p2 < disable_password.patch --ignore-whitespace


#RUN autoreconf --install
#RUN autoupdate
RUN ./autogen.sh

RUN ./configure --host=${TARGET_ARCH} --disable-socket-dir --enable-use-locale=no

#RUN ./configure --host=${TARGET_ARCH} --enable-pam=no --with-system_screenrc=no


RUN make -j4


RUN /bin/strip /root/screen/src/screen



#RUN upx --brute /root/htop/htop-${VERSION}/htop