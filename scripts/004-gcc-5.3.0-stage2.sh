#!/bin/bash
# gcc-5.3.0-stage2.sh by SP193
# Based on gcc-3.2.2-stage2.sh by Dan Peori (danpeori@oopo.net)

 GCC_VERSION=5.3.0
 ## Download the source code.
 SOURCE=http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2
 wget --continue $SOURCE || { exit 1; }

 ## Unpack the source code.
 echo Decompressing GCC $GCC_VERSION. Please wait.
 rm -Rf gcc-$GCC_VERSION && tar xfj gcc-$GCC_VERSION.tar.bz2 || { exit 1; }

 ## Enter the source directory and patch the source code.
 cd gcc-$GCC_VERSION || { exit 1; }

 ## Apply the uncommitted patches first (libgcc, short-loop bug, EE-core extensions, MMI)
 ## TODO: Remove these lines, once the patches are submitted.
 cat ../../patches/gcc-$GCC_VERSION-gperf.patch | patch -p2 || { exit 1; }
 cat ../../patches/gcc-$GCC_VERSION-libgcc.patch | patch -p1 || { exit 1; }
 cat ../../patches/gcc-$GCC_VERSION-ee.patch | patch -p1 || { exit 1; }
 cat ../../patches/gcc-$GCC_VERSION-mmi.patch | patch -p1 || { exit 1; }

 if [ -e ../../patches/gcc-$GCC_VERSION-PS2.patch ]; then
 	cat ../../patches/gcc-$GCC_VERSION-PS2.patch | patch -p1 || { exit 1; }
 fi

 TARG_NAME=ee
 TARGET=mips64r5900el-ps2-elf
 TARG_XTRA_OPTS="--with-float=hard --with-newlib"

 ## Create and enter the build directory.
 mkdir build-$TARG_NAME-stage2 && cd build-$TARG_NAME-stage2 || { exit 1; }

 ## Configure the build.
 ../configure --prefix="$PS2DEV/$TARG_NAME" --target="$TARGET" --enable-languages="c,c++" --disable-nls --disable-shared --disable-libssp --disable-libmudflap --disable-threads --disable-libgomp --disable-libquadmath --disable-target-libiberty --disable-target-zlib --without-ppl --without-cloog --with-headers=no --disable-libada --disable-libatomic --disable-multilib --with-headers="$PS2DEV/$TARG_NAME/$TARGET/include" $TARG_XTRA_OPTS || { exit 1; }

 ## Determine the maximum number of processes that Make can work with.
 ## MinGW's Make doesn't work properly with multi-core processors.
 OSVER=$(uname)
 if [ ${OSVER:0:10} == MINGW32_NT ]; then
 	PROC_NR=2
 else
 	PROC_NR=$(nproc)
 fi

 ## Compile and install.
 make clean && make -j $PROC_NR && make install && make clean || { exit 1; }
