#!/usr/bin/env bash
# Build Boost 1.65.0 with context/fiber/process libraries
BOOST_VERSION=1.65.0
BOOST_LIBS="chrono date_time filesystem graph locale random regex signals system thread context fiber process"
export BOOST_VERSION BOOST_LIBS

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

WORK_DIR=$(mktemp -d /tmp/ofxiosboost.XXXXXX)
export WORK_DIR

cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

echo "Working in $WORK_DIR"
echo "Libraries: $BOOST_LIBS"

# Download
SOURCE_ARCHIVE="$WORK_DIR/boost_1_65_0.tar.bz2"
if [[ ! -f "$SOURCE_ARCHIVE" ]]; then
    echo "Downloading Boost $BOOST_VERSION..."
    curl -L -o "$SOURCE_ARCHIVE" "https://archives.boost.io/release/1.65.0/source/boost_1_65_0.tar.bz2"
fi

echo "Extracting..."
tar -xjf "$SOURCE_ARCHIVE" -C "$WORK_DIR"

SOURCE_DIR="$WORK_DIR/boost_1_65_0"
echo "Source at $SOURCE_DIR"

# Bootstrap
LIBS_CSV="${BOOST_LIBS// /,}"
echo "Bootstrapping with libs: $LIBS_CSV"
./bootstrap.sh --with-toolset=cc --with-libraries="$LIBS_CSV" 2>&1 | tail -10
rm -f project-config.jam

# Check if context/fiber/process have pre-compiled libs for iOS
cat > "$WORK_DIR/user-config.jam" <<EOF
using darwin : iosdevice
     : clang-c++
     : <compileflags>"-isysroot $(xcrun --sdk iphoneos --show-sdk-path) -miphoneos-version-min=12.0 -fPIC -DBOOST_SP_USE_SPINLOCK -std=c++14 -stdlib=libc++ -fvisibility=hidden -fvisibility-inlines-hidden -Wno-deprecated-declarations -Wno-deprecated-builtins -Wno-unknown-warning-option"
       <linkflags>"-isysroot $(xcrun --sdk iphoneos --show-sdk-path) -miphoneos-version-min=12.0 -stdlib=libc++"
     ;
using darwin : iosimulator
     : clang-c++
     : <compileflags>"-isysroot $(xcrun --sdk iphonesimulator --show-sdk-path) -mios-simulator-version-min=12.0 -fPIC -DBOOST_SP_USE_SPINLOCK -std=c++14 -stdlib=libc++ -fvisibility=hidden -fvisibility-inlines-hidden -Wno-deprecated-declarations -Wno-deprecated-builtins -Wno-unknown-warning-option"
       <linkflags>"-isysroot $(xcrun --sdk iphonesimulator --show-sdk-path) -mios-simulator-version-min=12.0 -stdlib=libc++"
     ;
EOF

echo "Building device-arm64..."
cd "$SOURCE_DIR"
time ./b2 -j$(sysctl -n hw.logicalcpu 2>/dev/null || echo 4) \
    ${BOOST_LIBS// / --with} --with-context --with-fiber --with-process \
    --user-config="$WORK_DIR/user-config.jam" \
    --build-dir="$WORK_DIR/device-arm64" \
    --stagedir="$WORK_DIR/device-arm64/stage" \
    toolset=darwin-iosdevice architecture=arm address-model=64 \
    target-os=iphone variant=release link=static runtime-link=static threading=multi \
    stage 2>&1 | tail -30

echo "Build device-arm64 phase complete"
