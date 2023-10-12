#!/bin/bash -ex
# -e: Exit immediately if a command exits with a non-zero status.
# -x: Display expanded script commands

# use as build.sh <dest dir> (i.e. the files will be installed to <dest dir>/<sys-root>/usr)

export ASFLAGS="-m68020-60"
export CXXFLAGS="-m68020-60 -DUSE_MOVE16 -DUSE_SUPERVIDEL -DUSE_SV_BLITTER"
export LDFLAGS="-m68020-60"
export PREFIX="$($TOOL_PREFIX-gcc -print-sysroot)/usr"
export PKG_CONFIG_LIBDIR="$PREFIX/lib/m68020-60/pkgconfig"

export CONFIGURE_FLAGS="$CONFIGURE_FLAGS
    --bindir=$PREFIX/bin/m68020-60 --sbindir=$PREFIX/sbin/m68020-60 --libdir=$PREFIX/lib/m68020-60 \
	--prefix=$PREFIX \
	--backend=atari \
	--host=${TOOL_PREFIX} \
	--enable-release \
	--disable-mt32emu \
	--disable-lua \
	--disable-nuked-opl \
	--disable-16bit \
	--disable-scalers \
	--disable-translation \
	--disable-eventrecorder \
	--disable-tts \
	--disable-bink \
	--opengl-mode=none \
	--enable-verbose-build \
	--enable-text-console \
	--disable-engine=director,cine"

./configure $CONFIGURE_FLAGS
make
make install DESTDIR="$1"
