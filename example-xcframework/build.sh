#!/usr/bin/env bash

set -euo pipefail

BOOST_VERSION="${BOOST_VERSION:-1.61.0}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ARCHIVE="${1:-}"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ofxiosboost-example.XXXXXX")"

cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

if [[ -z "$ARCHIVE" ]]; then
    ARCHIVE="$WORK_DIR/ofxiOSBoost-${BOOST_VERSION}.tar.gz"
    CHECKSUM="$ARCHIVE.sha256"
    RELEASE_URL="https://github.com/danoli3/ofxiOSBoost/releases/download/boost-${BOOST_VERSION}"

    echo "Downloading published Boost $BOOST_VERSION release"
    curl --fail --location --retry 3 \
        "$RELEASE_URL/ofxiOSBoost-${BOOST_VERSION}.tar.gz" --output "$ARCHIVE"
    curl --fail --location --retry 3 \
        "$RELEASE_URL/ofxiOSBoost-${BOOST_VERSION}.tar.gz.sha256" --output "$CHECKSUM"

    expected_hash="$(awk 'NR == 1 { print $1 }' "$CHECKSUM")"
    actual_hash="$(shasum -a 256 "$ARCHIVE" | awk '{ print $1 }')"
    [[ "$actual_hash" == "$expected_hash" ]] || {
        echo "Release checksum does not match." >&2
        exit 1
    }
else
    ARCHIVE="$(cd "$(dirname "$ARCHIVE")" && pwd)/$(basename "$ARCHIVE")"
    [[ -s "$ARCHIVE" ]] || { echo "Archive not found: $ARCHIVE" >&2; exit 1; }
fi

tar -xzf "$ARCHIVE" -C "$WORK_DIR"
PACKAGE_DIR="$WORK_DIR/ofxiOSBoost-${BOOST_VERSION}"
XCFRAMEWORK="$PACKAGE_DIR/boost.xcframework"
SIMULATOR_DIR="$XCFRAMEWORK/ios-arm64_x86_64-simulator"
LIBRARY="$SIMULATOR_DIR/libboost-simulator.a"
HEADERS="$SIMULATOR_DIR/Headers"
DEVICE_DIR="$XCFRAMEWORK/ios-arm64"
DEVICE_LIBRARY="$DEVICE_DIR/libboost-device-arm64.a"
DEVICE_HEADERS="$DEVICE_DIR/Headers"

plutil -lint "$XCFRAMEWORK/Info.plist" >/dev/null
for metadata in \
    "$XCFRAMEWORK/ios-arm64/boost.pkl" \
    "$XCFRAMEWORK/ios-arm64/boost-components.txt" \
    "$XCFRAMEWORK/ios-arm64_x86_64-simulator/boost.pkl" \
    "$XCFRAMEWORK/ios-arm64_x86_64-simulator/boost-components.txt" \
    "$PACKAGE_DIR/COMPONENTS.md" \
    "$PACKAGE_DIR/cmake/ofxiOSBoost/ofxiOSBoostConfig.cmake" \
    "$PACKAGE_DIR/cmake/ofxiOSBoost/ofxiOSBoostConfigVersion.cmake" \
    "$PACKAGE_DIR/pkgconfig/ofxiOSBoost-ios.pc" \
    "$PACKAGE_DIR/pkgconfig/ofxiOSBoost-ios-simulator.pc"; do
    [[ -s "$metadata" ]] || { echo "Missing package metadata: $metadata" >&2; exit 1; }
done
[[ "$(xcrun lipo -archs "$LIBRARY")" == "x86_64 arm64" ]] || {
    echo "Unexpected Simulator architectures in $LIBRARY" >&2
    exit 1
}

SDK_PATH="$(xcrun --sdk iphonesimulator --show-sdk-path)"
for architecture in arm64 x86_64; do
    output="$WORK_DIR/xcframework-example-$architecture"
    echo "Compiling and linking iOS Simulator example for $architecture"
    xcrun --sdk iphonesimulator clang++ \
        -arch "$architecture" \
        -isysroot "$SDK_PATH" \
        -mios-simulator-version-min=12.0 \
        -std=c++11 -stdlib=libc++ \
        -Wno-deprecated-declarations -Wno-deprecated-builtins \
        -I"$HEADERS" \
        "$SCRIPT_DIR/main.cpp" "$LIBRARY" \
        -o "$output"
    [[ "$(xcrun lipo -archs "$output")" == "$architecture" ]]
done

echo "Compiling and linking iOS device example for arm64"
DEVICE_SDK_PATH="$(xcrun --sdk iphoneos --show-sdk-path)"
xcrun --sdk iphoneos clang++ \
    -arch arm64 \
    -isysroot "$DEVICE_SDK_PATH" \
    -miphoneos-version-min=12.0 \
    -std=c++11 -stdlib=libc++ \
    -Wno-deprecated-declarations -Wno-deprecated-builtins \
    -I"$DEVICE_HEADERS" \
    "$SCRIPT_DIR/main.cpp" "$DEVICE_LIBRARY" \
    -o "$WORK_DIR/xcframework-example-device-arm64"
[[ "$(xcrun lipo -archs "$WORK_DIR/xcframework-example-device-arm64")" == "arm64" ]]

echo "Boost $BOOST_VERSION XCFramework example built successfully for all device and Simulator slices."
