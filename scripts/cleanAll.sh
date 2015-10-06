#===============================================================================
# Filename:  cleanAll.sh
# Author:    Pete Goodliffe, Daniel Rosser
# Copyright: (c) Copyright 2009 Pete Goodliffe, 2013 Daniel Rosser
# Licence:   Please feel free to use this, with attribution
# Modified version ## for ofxiOSBoost
#===============================================================================
#
# Cleans the Build Boost framework environment for the iPhone.
#===============================================================================

#!/bin/sh
here="`dirname \"$0\"`"
echo "cd-ing to $here"
cd "$here" || exit 1

CPPSTD=c++98    #c++11, c++99, c++14
STDLIB=libstdc++   # libc++
COMPILER=clang++

BOOST_V1=1.59.0
BOOST_V2=1_59_0

CURRENTPATH=`pwd`
LOGDIR="$CURRENTPATH/build/logs/"

SDKVERSION=`xcrun -sdk iphoneos --show-sdk-version`
OSX_SDKVERSION=`xcrun -sdk macosx --show-sdk-version`
DEVELOPER=`xcode-select -print-path`
XCODE_ROOT=`xcode-select -print-path`

if [ ! -d "$DEVELOPER" ]; then
  echo "xcode path is not set correctly $DEVELOPER does not exist (most likely because of xcode > 4.3)"
  echo "run"
  echo "sudo xcode-select -switch <xcode path>"
  echo "for default installation:"
  echo "sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer"
  exit 1
fi

case $DEVELOPER in  
     *\ * )
           echo "Your Xcode path contains whitespaces, which is not supported."
           exit 1
          ;;
esac

case $CURRENTPATH in  
     *\ * )
           echo "Your path contains whitespaces, which is not supported by 'make install'."
           exit 1
          ;;
esac

: ${BOOST_LIBS:="random regex graph random chrono thread signals filesystem system date_time"}
: ${IPHONE_SDKVERSION:=`xcodebuild -showsdks | grep iphoneos | egrep "[[:digit:]]+\.[[:digit:]]+" -o | tail -1`}
: ${EXTRA_CPPFLAGS:="-DBOOST_AC_USE_PTHREADS -DBOOST_SP_USE_PTHREADS -std=$CPPSTD -stdlib=$STDLIB"}

# The EXTRA_CPPFLAGS definition works around a thread race issue in
# shared_ptr. I encountered this historically and have not verified that
# the fix is no longer required. Without using the posix thread primitives
# an invalid compare-and-swap ARM instruction (non-thread-safe) was used for the
# shared_ptr use count causing nasty and subtle bugs.
#
# Should perhaps also consider/use instead: -BOOST_SP_USE_PTHREADS

: ${TARBALLDIR:=`pwd`/..}
: ${SRCDIR:=`pwd`/../build/src}
: ${IOSBUILDDIR:=`pwd`/../build/libs/boost/lib}
: ${IOSINCLUDEDIR:=`pwd`/../build/libs/boost/include/boost}
: ${PREFIXDIR:=`pwd`/../build/ios/prefix}
: ${COMPILER:="clang++"}
: ${OUTPUT_DIR:=`pwd`/../libs/boost/}
: ${OUTPUT_DIR_LIB:=`pwd`/../libs/boost/ios/}
: ${OUTPUT_DIR_SRC:=`pwd`/../libs/boost/include/boost}

: ${BOOST_VERSION:=$BOOST_V1}
: ${BOOST_VERSION2:=$BOOST_V2}

BOOST_TARBALL=$TARBALLDIR/boost_$BOOST_VERSION2.tar.bz2
BOOST_SRC=$SRCDIR/boost_${BOOST_VERSION2}
BOOST_INCLUDE=$BOOST_SRC/boost



#===============================================================================
ARM_DEV_CMD="xcrun --sdk iphoneos"
SIM_DEV_CMD="xcrun --sdk iphonesimulator"
OSX_DEV_CMD="xcrun --sdk macosx"

ARM_COMBINED_LIB=$IOSBUILDDIR/lib_boost_arm.a

#===============================================================================


#===============================================================================
# Functions
#===============================================================================

abort()
{
    echo
    echo "Aborted: $@"
    exit 1
}

doneSection()
{
    echo
    echo "================================================================="
    echo "Done"
    echo
}

#===============================================================================

cleanEverythingReadyToStart()
{
    echo Cleaning everything before we start to build...

    rm -rf iphone-build iphonesim-build osx-build
    rm -rf $IOSBUILDDIR
    rm -rf $PREFIXDIR
    rm -rf $IOSINCLUDEDIR
    rm -rf $TARBALLDIR/build
    rm -rf $LOGDIR

    doneSection
}

postcleanEverything()
{
	echo Cleaning everything after the build...

	rm -rf iphone-build iphonesim-build osx-build
	rm -rf $PREFIXDIR
	rm -rf $IOSBUILDDIR/armv6/obj
    rm -rf $IOSBUILDDIR/armv7/obj
    rm -rf $IOSBUILDDIR/armv7s/obj
	rm -rf $IOSBUILDDIR/arm64/obj
    rm -rf $IOSBUILDDIR/i386/obj
	rm -rf $IOSBUILDDIR/x86_64/obj
    rm -rf $TARBALLDIR/build
    rm -rf $LOGDIR
	doneSection
}

cleanBuild() {
    rm -rf `pwd`/../build/
}


cleanEverythingReadyToStart #may want to comment if repeatedly running during dev
postcleanEverything
cleanBuild

echo "Completed Clean successfully"

#===============================================================================
