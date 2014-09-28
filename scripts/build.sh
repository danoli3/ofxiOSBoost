#===============================================================================
# Filename:  boost.sh
# Author:    Pete Goodliffe, Daniel Rosser
# Copyright: (c) Copyright 2009 Pete Goodliffe, 2013 Daniel Rosser
# Licence:   Please feel free to use this, with attribution
# Modified version ## for ofxiOSBoost
#===============================================================================
#
# Builds a Boost framework for the iPhone.
# Creates a set of universal libraries that can be used on an iPhone and in the
# iPhone simulator. Then creates a pseudo-framework to make using boost in Xcode
# less painful.
#
# To configure the script, define:
#    BOOST_LIBS:        which libraries to build
#    IPHONE_SDKVERSION: iPhone SDK version (e.g. 5.1)
#
# Then go get the source tar.bz of the boost you want to build, shove it in the
# same directory as this script, and run "./boost.sh". Grab a cuppa. And voila.
#===============================================================================

#!/bin/sh
here="`dirname \"$0\"`"
echo "cd-ing to $here"
cd "$here" || exit 1

#IOS_ARCH ?="armv7 armv7s arm64"   # armv6
#SIM_ARCH ?="i386 x86_64"
CPPSTD=c++11    #c++89, c++99, c++14
STDLIB=libc++   # libstdc++
COMPILER=clang++

BOOST_V1=1.55.0
BOOST_V2=1_55_0


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
: ${IPHONE_SDKVERSION:=`$SDKVERSION | grep iphoneos | egrep "[[:digit:]]+\.[[:digit:]]+" -o | tail -1`}
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

: ${BOOST_VERSION:=1.55.0}
: ${BOOST_VERSION2:=1_55_0}

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

    doneSection
}

postcleanEverything()
{
	echo Cleaning everything after the build...

	rm -rf iphone-build iphonesim-build osx-build
	rm -rf $PREFIXDIR
	rm -rf  $IOSBUILDDIR/armv6/obj
    rm -rf  $IOSBUILDDIR/armv7/obj
    rm -rf  $IOSBUILDDIR/armv7s/obj
	rm -rf  $IOSBUILDDIR/arm64/obj
    rm -rf  $IOSBUILDDIR/i386/obj
	rm -rf  $IOSBUILDDIR/x86_64/obj
    rm -rf $TARBALLDIR/build
	doneSection
}

prepare()
{
    CURRENTPATH=`pwd`
    LOGDIR="$CURRENTPATH/build/logs/"
    mkdir -p $LOGDIR

    mkdir -p $OUTPUT_DIR
    mkdir -p $OUTPUT_DIR_SRC
    mkdir -p $OUTPUT_DIR_LIB

}

#===============================================================================

downloadBoost()
{
    if [ ! -s $TARBALLDIR/boost_${BOOST_VERSION2}.tar.bz2 ]; then
        echo "Downloading boost ${BOOST_VERSION}"
        curl -L -o $TARBALLDIR/boost_${BOOST_VERSION2}.tar.bz2 http://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION2}.tar.bz2/download
    fi

    doneSection
}

#===============================================================================

unpackBoost()
{
    [ -f "$BOOST_TARBALL" ] || abort "Source tarball missing."

    echo Unpacking boost into $SRCDIR...

    [ -d $SRCDIR ]    || mkdir -p $SRCDIR
    [ -d $BOOST_SRC ] || ( cd $SRCDIR; tar xfj $BOOST_TARBALL )
    [ -d $BOOST_SRC ] && echo "    ...unpacked as $BOOST_SRC"

    doneSection
}

#===============================================================================

restoreBoost()
{
    cp $BOOST_SRC/tools/build/v2/user-config.jam-bk $BOOST_SRC/tools/build/v2/user-config.jam
}

#===============================================================================

updateBoost()
{
    echo Updating boost into $BOOST_SRC...

    cp $BOOST_SRC/tools/build/v2/user-config.jam $BOOST_SRC/tools/build/v2/user-config.jam.bk

    cat >> $BOOST_SRC/tools/build/v2/user-config.jam <<EOF
using darwin : ${IPHONE_SDKVERSION}~iphone
: $XCODE_ROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/$COMPILER -arch armv7 -arch armv7s -arch arm64 -fvisibility=hidden -fvisibility-inlines-hidden $EXTRA_CPPFLAGS
: <striper> <root>$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer
: <architecture>arm <target-os>iphone
;
using darwin : ${IPHONE_SDKVERSION}~iphonesim
: $XCODE_ROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/$COMPILER -arch i386 -arch x86_64 -fvisibility=hidden -fvisibility-inlines-hidden $EXTRA_CPPFLAGS
: <striper> <root>$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer
: <architecture>x86 <target-os>iphone
;
EOF

    doneSection
}

#===============================================================================

inventMissingHeaders()
{
    # These files are missing in the ARM iPhoneOS SDK, but they are in the simulator.
    # They are supported on the device, so we copy them from x86 SDK to a staging area
    # to use them on ARM, too.
    echo Invent missing headers

    cp $XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${IPHONE_SDKVERSION}.sdk/usr/include/{crt_externs,bzlib}.h $BOOST_SRC
}

#===============================================================================

bootstrapBoost()
{
    cd $BOOST_SRC

    BOOST_LIBS_COMMA=$(echo $BOOST_LIBS | sed -e "s/ /,/g")
    echo "Bootstrapping (with libs $BOOST_LIBS_COMMA)"
    ./bootstrap.sh --with-libraries=$BOOST_LIBS_COMMA

    doneSection
}

#===============================================================================

buildBoostForIPhoneOS()
{
    cd $BOOST_SRC

    # Install this one so we can copy the includes for the frameworks...

    
    set +e    
    echo "------------------"
    LOG="$LOGDIR/build-iphone-stage.log"
    ./bjam -j16 --build-dir=iphone-build --stagedir=iphone-build/stage --prefix=$PREFIXDIR toolset=darwin architecture=arm target-os=iphone macosx-version=iphone-${IPHONE_SDKVERSION} define=_LITTLE_ENDIAN link=static stage > "${LOG}" 2>&1
    if [ $? != 0 ]; then 
        echo "Problem while Building iphone-build stage - Please check ${LOG}"
        exit 1
    else 
        echo "iphone-build stage successful"
    fi

    echo "------------------"
    LOG="$LOGDIR/build-iphone-install.log"
    ./bjam -j16 --build-dir=iphone-build --stagedir=iphone-build/stage --prefix=$PREFIXDIR toolset=darwin architecture=arm target-os=iphone macosx-version=iphone-${IPHONE_SDKVERSION} define=_LITTLE_ENDIAN link=static install > "${LOG}" 2>&1
    if [ $? != 0 ]; then 
        echo "Problem while Building iphone-build install - Please check ${LOG}"
        exit 1
    else 
        echo "iphone-build install successful"
    fi
    doneSection

    echo "------------------"
    LOG="$LOGDIR/build-iphone-simulator-build.log"
    ./bjam -j16 --build-dir=iphonesim-build --stagedir=iphonesim-build/stage --toolset=darwin-${IPHONE_SDKVERSION}~iphonesim architecture=x86 target-os=iphone macosx-version=iphonesim-${IPHONE_SDKVERSION} link=static stage > "${LOG}" 2>&1
    if [ $? != 0 ]; then 
        echo "Problem while Building iphone-simulator build - Please check ${LOG}"
        exit 1
    else 
        echo "iphone-simulator build successful"
    fi

    doneSection
}

#===============================================================================

scrunchAllLibsTogetherInOneLibPerPlatform()
{
    cd $BOOST_SRC

    mkdir -p $IOSBUILDDIR/armv7/obj
    mkdir -p $IOSBUILDDIR/armv7s/obj
	mkdir -p $IOSBUILDDIR/arm64/obj
    mkdir -p $IOSBUILDDIR/i386/obj
	mkdir -p $IOSBUILDDIR/x86_64/obj

    ALL_LIBS=""

    echo Splitting all existing fat binaries...

    for NAME in $BOOST_LIBS; do
        ALL_LIBS="$ALL_LIBS libboost_$NAME.a"

        $ARM_DEV_CMD lipo "iphone-build/stage/lib/libboost_$NAME.a" -thin armv7 -o $IOSBUILDDIR/armv7/libboost_$NAME.a
        $ARM_DEV_CMD lipo "iphone-build/stage/lib/libboost_$NAME.a" -thin armv7s -o $IOSBUILDDIR/armv7s/libboost_$NAME.a
		$ARM_DEV_CMD lipo "iphone-build/stage/lib/libboost_$NAME.a" -thin arm64 -o $IOSBUILDDIR/arm64/libboost_$NAME.a

		$ARM_DEV_CMD lipo "iphonesim-build/stage/lib/libboost_$NAME.a" -thin i386 -o $IOSBUILDDIR/i386/libboost_$NAME.a
		$ARM_DEV_CMD lipo "iphonesim-build/stage/lib/libboost_$NAME.a" -thin x86_64 -o $IOSBUILDDIR/x86_64/libboost_$NAME.a
  
    done

    echo "Decomposing each architecture's .a files"

    for NAME in $ALL_LIBS; do
        echo Decomposing $NAME...
        (cd $IOSBUILDDIR/armv7/obj; ar -x ../$NAME );
        (cd $IOSBUILDDIR/armv7s/obj; ar -x ../$NAME );
		(cd $IOSBUILDDIR/arm64/obj; ar -x ../$NAME );
        (cd $IOSBUILDDIR/i386/obj; ar -x ../$NAME );
		(cd $IOSBUILDDIR/x86_64/obj; ar -x ../$NAME );
    done

    echo "Linking each architecture into an uberlib ($ALL_LIBS => libboost.a )"

    rm $IOSBUILDDIR/*/libboost.a
    
    echo ...armv7
    (cd $IOSBUILDDIR/armv7; $ARM_DEV_CMD ar crus libboost.a obj/*.o; )
    echo ...armv7s
    (cd $IOSBUILDDIR/armv7s; $ARM_DEV_CMD ar crus libboost.a obj/*.o; )
    echo ...arm64
    (cd $IOSBUILDDIR/arm64; $ARM_DEV_CMD ar crus libboost.a obj/*.o; )
    echo ...i386
    (cd $IOSBUILDDIR/i386;  $SIM_DEV_CMD ar crus libboost.a obj/*.o; )
    echo ...x86_64
    (cd $IOSBUILDDIR/x86_64;  $SIM_DEV_CMD ar crus libboost.a obj/*.o; )

    echo "Making fat lib for iOS Boost $BOOST_VERSION"
    lipo -c $IOSBUILDDIR/armv7/libboost.a \
            $IOSBUILDDIR/armv7s/libboost.a \
            $IOSBUILDDIR/arm64/libboost.a \
            $IOSBUILDDIR/i386/libboost.a \
            $IOSBUILDDIR/x86_64/libboost.a \
            -output $OUTPUT_DIR_LIB/boost.a

    echo "Completed Fat Lib"
    echo "------------------"

}

#===============================================================================
buildIncludes()
{
    
    mkdir -p $IOSINCLUDEDIR
    echo "------------------"
    echo "Copying Includes to Final Dir $OUTPUT_DIR_SRC"
    LOG="$LOGDIR/buildIncludes.log"
    set +e

    cp -r $PREFIXDIR/include/boost/*  $OUTPUT_DIR_SRC/ > "${LOG}" 2>&1
    if [ $? != 0 ]; then 
        echo "Problem while copying includes - Please check ${LOG}"
        exit 1
    else 
        echo "Copy of Includes successful"
    fi
    echo "------------------"

    doneSection
}

#===============================================================================
# Execution starts here
#===============================================================================

mkdir -p $IOSBUILDDIR

cleanEverythingReadyToStart #may want to comment if repeatedly running during dev
restoreBoost

echo "BOOST_VERSION:     $BOOST_VERSION"
echo "BOOST_LIBS:        $BOOST_LIBS"
echo "BOOST_SRC:         $BOOST_SRC"
echo "IOSBUILDDIR:       $IOSBUILDDIR"
echo "OSXBUILDDIR:       $OSXBUILDDIR"
echo "PREFIXDIR:         $PREFIXDIR"
echo "IOSFRAMEWORKDIR:   $IOSFRAMEWORKDIR"
echo "OSXFRAMEWORKDIR:   $OSXFRAMEWORKDIR"
echo "IPHONE_SDKVERSION: $IPHONE_SDKVERSION"
echo "XCODE_ROOT:        $XCODE_ROOT"
echo "COMPILER:          $COMPILER"
echo

downloadBoost
unpackBoost
#inventMissingHeaders
prepare
bootstrapBoost
updateBoost
buildBoostForIPhoneOS
scrunchAllLibsTogetherInOneLibPerPlatform
buildIncludes

restoreBoost

postcleanEverything

echo "Completed successfully"

#===============================================================================
