#!/bin/bash
# newlib-1.10.0.sh by Naomi Peori (naomi@peori.ca)

# Source the PS2DEV environment
source ../ps2dev.sh || { exit 1; }

NEWLIB_VERSION=3.0.0.20180226
## Download the source code.
SOURCE=ftp://sourceware.org/pub/newlib/newlib-$NEWLIB_VERSION.tar.gz
if [ ! -e newlib-$NEWLIB_VERSION.tar.gz ]; then
	wget --continue $SOURCE || { exit 1; }
fi

## Unpack the source code.
echo Decompressing newlib $NEWLIB_VERSION. Please wait.
rm -Rf newlib-$NEWLIB_VERSION && tar xfz newlib-$NEWLIB_VERSION.tar.gz || { exit 1; }

## Enter the source directory and patch the source code.
cd newlib-$NEWLIB_VERSION || { exit 1; }
if [ -e ../../patches/newlib-$NEWLIB_VERSION-PS2.patch ]; then
	cat ../../patches/newlib-$NEWLIB_VERSION-PS2.patch | patch -p1 || { exit 1; }
fi

## Determine the maximum number of processes that Make can work with.
## MinGW's Make doesn't work properly with multi-core processors.
OSVER=$(uname)
if [ ${OSVER:0:10} == MINGW32_NT ]; then
	PROC_NR=2
elif [ ${OSVER:0:6} == Darwin ]; then
	PROC_NR=$(sysctl -n hw.ncpu)
else
	PROC_NR=$(nproc)
fi

## Move outside of source directory.
cd .. || { exit 1; }

TARGET="ee"

## Create and enter the build directory.
rm -Rf build-$TARGET-newlib && mkdir build-$TARGET-newlib && cd build-$TARGET-newlib || { exit 1; }

## Configure the build.
../newlib-$NEWLIB_VERSION/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" || { exit 1; }

## Compile and install.
make clean && make -j $PROC_NR && make install && make clean || { exit 1; }
