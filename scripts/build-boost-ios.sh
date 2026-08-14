#!/usr/bin/env bash

set -euo pipefail

BOOST_VERSION="${BOOST_VERSION:-1.78.0}"
DEFAULT_BOOST_LIBS="chrono date_time filesystem graph locale random regex system thread"
case "$BOOST_VERSION" in
    1.61.0|1.62.0|1.63.0|1.64.0|1.65.0|1.66.0|1.67.0|1.68.0)
        DEFAULT_BOOST_LIBS="$DEFAULT_BOOST_LIBS signals"
        ;;
esac
if [[ "$BOOST_VERSION" == "1.65.0" || "$BOOST_VERSION" == "1.66.0" || "$BOOST_VERSION" == "1.67.0" || "$BOOST_VERSION" == "1.68.0" || "$BOOST_VERSION" == "1.69.0" || "$BOOST_VERSION" == "1.70.0" || "$BOOST_VERSION" == "1.71.0" || "$BOOST_VERSION" == "1.72.0" || "$BOOST_VERSION" == "1.73.0" || "$BOOST_VERSION" == "1.74.0" || "$BOOST_VERSION" == "1.75.0" ]]; then
    DEFAULT_BOOST_LIBS="$DEFAULT_BOOST_LIBS context"
fi
if [[ "$BOOST_VERSION" == "1.76.0" || "$BOOST_VERSION" == "1.77.0" || "$BOOST_VERSION" == "1.78.0" ]]; then
    # Regex is header-only in C++11 and newer beginning with Boost 1.76.
    DEFAULT_BOOST_LIBS="${DEFAULT_BOOST_LIBS/ regex/} context nowide json serialization"
fi
if [[ "$BOOST_VERSION" == "1.73.0" || "$BOOST_VERSION" == "1.74.0" || "$BOOST_VERSION" == "1.75.0" ]]; then
    DEFAULT_BOOST_LIBS="$DEFAULT_BOOST_LIBS nowide"
fi
if [[ "$BOOST_VERSION" == "1.75.0" ]]; then
    DEFAULT_BOOST_LIBS="$DEFAULT_BOOST_LIBS json serialization"
fi
BOOST_LIBS="${BOOST_LIBS:-$DEFAULT_BOOST_LIBS}"
IOS_MIN_VERSION="${IOS_MIN_VERSION:-12.0}"

case "$BOOST_VERSION" in
    1.61.0|1.62.0|1.63.0|1.64.0|1.65.0|1.66.0|1.67.0|1.68.0|1.69.0|1.70.0|1.71.0|1.72.0|1.73.0|1.74.0|1.75.0|1.76.0|1.77.0|1.78.0) ;;
    *) echo "Boost $BOOST_VERSION is not supported by this build script yet." >&2; exit 2 ;;
esac

BOOST_MINOR="$(printf '%s' "$BOOST_VERSION" | cut -d. -f2)"
if (( BOOST_MINOR <= 64 )); then
    DEFAULT_CPPSTD=c++11
elif (( BOOST_MINOR <= 67 )); then
    DEFAULT_CPPSTD=c++14
elif (( BOOST_MINOR <= 79 )); then
    DEFAULT_CPPSTD=c++17
else
    DEFAULT_CPPSTD=c++20
fi
CPPSTD="${CPPSTD:-$DEFAULT_CPPSTD}"

command -v xcrun >/dev/null || { echo "Xcode command line tools are required." >&2; exit 1; }
command -v curl >/dev/null || { echo "curl is required." >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPONENT_MANIFEST="$REPO_ROOT/packaging/versions/$BOOST_VERSION-components.tsv"
[[ -s "$COMPONENT_MANIFEST" ]] || { echo "Missing component manifest: $COMPONENT_MANIFEST" >&2; exit 1; }
AVAILABLE_LIBS="$(awk -F '\t' '$1 == "included" || $1 == "excluded" { print $2 }' "$COMPONENT_MANIFEST" | paste -sd ' ' -)"
for library in $BOOST_LIBS; do
    [[ " $AVAILABLE_LIBS " == *" $library "* ]] || {
        echo "Unknown compiled library '$library' for Boost $BOOST_VERSION." >&2
        exit 2
    }
done
EXCLUDED_LIBS=""
for library in $AVAILABLE_LIBS; do
    if [[ " $BOOST_LIBS " != *" $library "* ]]; then
        EXCLUDED_LIBS="${EXCLUDED_LIBS:+$EXCLUDED_LIBS }$library"
    fi
done
VERSION_UNDERSCORED="${BOOST_VERSION//./_}"
ARCHIVE_NAME="ofxiOSBoost-${BOOST_VERSION}"
DIST_DIR="${DIST_DIR:-$REPO_ROOT/dist}"
DOWNLOAD_CACHE="${BOOST_DOWNLOAD_CACHE:-${TMPDIR:-/tmp}/ofxiOSBoost-downloads}"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ofxiosboost.XXXXXX")"
SOURCE_ARCHIVE="$WORK_DIR/boost_${VERSION_UNDERSCORED}.tar.bz2"
SOURCE_DIR="$WORK_DIR/boost_${VERSION_UNDERSCORED}"
BUILD_DIR="$WORK_DIR/build"
PACKAGE_DIR="$WORK_DIR/$ARCHIVE_NAME"

cleanup() {
    local status=$?
    rm -rf "$WORK_DIR"
    return "$status"
}
trap cleanup EXIT

JOBS="${JOBS:-$(sysctl -n hw.logicalcpu 2>/dev/null || echo 4)}"
IPHONEOS_SDK="$(xcrun --sdk iphoneos --show-sdk-path)"
SIMULATOR_SDK="$(xcrun --sdk iphonesimulator --show-sdk-path)"
MACOS_SDK="$(xcrun --sdk macosx --show-sdk-path)"
CLANGXX="$(xcrun --find clang++)"

echo "Downloading Boost $BOOST_VERSION"
mkdir -p "$DOWNLOAD_CACHE"
CACHED_ARCHIVE="$DOWNLOAD_CACHE/boost_${VERSION_UNDERSCORED}.tar.bz2"
if [[ ! -s "$CACHED_ARCHIVE" ]]; then
    curl --fail --location --retry 3 \
        "https://archives.boost.io/release/${BOOST_VERSION}/source/boost_${VERSION_UNDERSCORED}.tar.bz2" \
        --output "$CACHED_ARCHIVE.part"
    mv "$CACHED_ARCHIVE.part" "$CACHED_ARCHIVE"
fi
cp "$CACHED_ARCHIVE" "$SOURCE_ARCHIVE"
tar -xjf "$SOURCE_ARCHIVE" -C "$WORK_DIR"

echo "Applying Boost $BOOST_VERSION compatibility patches"
case "$BOOST_VERSION" in
    1.78.0)
        # Boost.Build gained native iPhone threading and architecture handling.
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.78.0-build-engine.patch"
        ;;
    1.77.0)
        # Boost 1.77 retains the same iOS build and Locale compatibility points.
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.76.0-build-engine.patch"
        ;;
    1.76.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.76.0-build-engine.patch"
        ;;
    1.75.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.75.0-build-engine.patch"
        ;;
    1.74.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.74.0-build-engine.patch"
        ;;
    1.73.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.73.0-build-engine.patch"
        ;;
    1.72.0)
        # Boost 1.72 retains the same source compatibility points as 1.71.
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.71.0-build-engine.patch"
        ;;
    1.71.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.71.0-build-engine.patch"
        ;;
    1.70.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.70.0-build-engine.patch"
        ;;
    1.69.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.69.0-build-engine.patch"
        ;;
    1.68.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.68.0-build-engine.patch"
        ;;
    1.67.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.67.0-build-engine.patch"
        ;;
    1.66.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.66.0-build-engine.patch"
        ;;
    1.65.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.65.0-build-engine.patch"
        ;;
    1.64.0)
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.64.0-build-engine.patch"
        ;;
    *)
        # Boost 1.61 through 1.63 share the original engine patch.
        COMPAT_PATCH="$REPO_ROOT/patches/boost-1.61.0-build-engine.patch"
        ;;
esac
patch -d "$SOURCE_DIR" -p1 < "$COMPAT_PATCH"
if [[ "$BOOST_VERSION" == "1.72.0" ]]; then
    patch -d "$SOURCE_DIR" -p1 < "$REPO_ROOT/patches/boost-1.72.0-histogram-span.patch"
fi

LIBS_CSV="${BOOST_LIBS// /,}"
WITH_LIBRARIES=()
for library in $BOOST_LIBS; do
    WITH_LIBRARIES+=("--with-$library")
done
HOST_TOOLSET=cc
if [[ "$BOOST_VERSION" == "1.71.0" || "$BOOST_VERSION" == "1.72.0" || "$BOOST_VERSION" == "1.73.0" || "$BOOST_VERSION" == "1.74.0" || "$BOOST_VERSION" == "1.75.0" || "$BOOST_VERSION" == "1.76.0" || "$BOOST_VERSION" == "1.77.0" || "$BOOST_VERSION" == "1.78.0" ]]; then
    HOST_TOOLSET=clang
fi
(
    cd "$SOURCE_DIR"
    # The host engine needs an explicit SDK with current Xcode command-line tools.
    if ! CC="$(xcrun --find clang)" \
        CFLAGS="${CFLAGS:-} -isysroot $MACOS_SDK" \
        ./bootstrap.sh --with-toolset="$HOST_TOOLSET" --with-libraries="$LIBS_CSV"; then
        tail -n 200 bootstrap.log >&2
        exit 1
    fi
    # The temporary host-only toolset is only needed to compile b2.
    # It is not a valid Boost.Build library toolset in this Boost release.
    rm -f project-config.jam
)

USER_CONFIG="$WORK_DIR/user-config.jam"
cat > "$USER_CONFIG" <<EOF
using darwin : iosdevice
    : $CLANGXX
    : <compileflags>"-arch arm64 -isysroot $IPHONEOS_SDK -miphoneos-version-min=$IOS_MIN_VERSION -fPIC -DBOOST_SP_USE_SPINLOCK -fvisibility=hidden -Wno-deprecated-declarations -Wno-deprecated-builtins -Wno-unknown-warning-option"
      <cxxflags>"-std=$CPPSTD -stdlib=libc++ -fvisibility-inlines-hidden"
      <linkflags>"-arch arm64 -isysroot $IPHONEOS_SDK -miphoneos-version-min=$IOS_MIN_VERSION -stdlib=libc++"
    ;
using darwin : iossimulatorarm64
    : $CLANGXX
    : <compileflags>"-arch arm64 -isysroot $SIMULATOR_SDK -mios-simulator-version-min=$IOS_MIN_VERSION -fPIC -DBOOST_SP_USE_SPINLOCK -fvisibility=hidden -Wno-deprecated-declarations -Wno-deprecated-builtins -Wno-unknown-warning-option"
      <cxxflags>"-std=$CPPSTD -stdlib=libc++ -fvisibility-inlines-hidden"
      <linkflags>"-arch arm64 -isysroot $SIMULATOR_SDK -mios-simulator-version-min=$IOS_MIN_VERSION -stdlib=libc++"
    ;
using darwin : iossimulatorx86_64
    : $CLANGXX
    : <compileflags>"-arch x86_64 -isysroot $SIMULATOR_SDK -mios-simulator-version-min=$IOS_MIN_VERSION -fPIC -DBOOST_SP_USE_SPINLOCK -fvisibility=hidden -Wno-deprecated-declarations -Wno-deprecated-builtins -Wno-unknown-warning-option"
      <cxxflags>"-std=$CPPSTD -stdlib=libc++ -fvisibility-inlines-hidden"
      <linkflags>"-arch x86_64 -isysroot $SIMULATOR_SDK -mios-simulator-version-min=$IOS_MIN_VERSION -stdlib=libc++"
    ;
EOF

build_platform() {
    local name="$1"
    local toolset="$2"
    local architecture="$3"
    local address_model="$4"
    local context_properties=()
    local locale_properties=()

    if [[ "$BOOST_VERSION" == "1.65.0" || "$BOOST_VERSION" == "1.66.0" || "$BOOST_VERSION" == "1.67.0" || "$BOOST_VERSION" == "1.68.0" || "$BOOST_VERSION" == "1.69.0" || "$BOOST_VERSION" == "1.70.0" || "$BOOST_VERSION" == "1.71.0" || "$BOOST_VERSION" == "1.72.0" || "$BOOST_VERSION" == "1.73.0" || "$BOOST_VERSION" == "1.74.0" || "$BOOST_VERSION" == "1.75.0" || "$BOOST_VERSION" == "1.76.0" || "$BOOST_VERSION" == "1.77.0" || "$BOOST_VERSION" == "1.78.0" ]]; then
        local abi=sysv
        if [[ "$architecture" == arm ]]; then
            abi=aapcs
        fi
        context_properties=(abi="$abi" binary-format=mach-o)
    fi
    if [[ ( "$BOOST_VERSION" == "1.70.0" || "$BOOST_VERSION" == "1.71.0" || "$BOOST_VERSION" == "1.72.0" || "$BOOST_VERSION" == "1.73.0" || "$BOOST_VERSION" == "1.74.0" || "$BOOST_VERSION" == "1.75.0" || "$BOOST_VERSION" == "1.76.0" || "$BOOST_VERSION" == "1.77.0" || "$BOOST_VERSION" == "1.78.0" ) && " $BOOST_LIBS " == *" locale "* ]]; then
        local platform_sdk="$SIMULATOR_SDK"
        if [[ "$name" == device-* ]]; then
            platform_sdk="$IPHONEOS_SDK"
        fi
        locale_properties=("-sICONV_PATH=$platform_sdk/usr")
    fi

    echo "Building $name"
    (
        cd "$SOURCE_DIR"
        ./b2 -j"$JOBS" \
            "${WITH_LIBRARIES[@]}" \
            --user-config="$USER_CONFIG" \
            --build-dir="$BUILD_DIR/$name" \
            --stagedir="$BUILD_DIR/$name/stage" \
            toolset="$toolset" architecture="$architecture" address-model="$address_model" \
            "${locale_properties[@]}" \
            "${context_properties[@]}" \
            target-os=iphone variant=release link=static runtime-link=static threading=multi \
            stage
    )

    for library in $BOOST_LIBS; do
        [[ -s "$BUILD_DIR/$name/stage/lib/libboost_$library.a" ]] || {
            echo "Missing requested library for $name: libboost_$library.a" >&2
            exit 1
        }
    done
    local libraries=("$BUILD_DIR/$name/stage/lib"/libboost_*.a)
    test -e "${libraries[0]}" || { echo "No libraries were produced for $name." >&2; exit 1; }
    xcrun libtool -static -o "$BUILD_DIR/libboost-$name.a" "${libraries[@]}"
}

build_platform device-arm64 darwin-iosdevice arm 64
build_platform simulator-arm64 darwin-iossimulatorarm64 arm 64
build_platform simulator-x86_64 darwin-iossimulatorx86_64 x86 64

mkdir -p "$PACKAGE_DIR/include" "$DIST_DIR"
cp -R "$SOURCE_DIR/boost" "$PACKAGE_DIR/include/"
cp "$REPO_ROOT/packaging/swiftpm/module.modulemap" "$PACKAGE_DIR/include/"
cp "$SOURCE_DIR/LICENSE_1_0.txt" "$PACKAGE_DIR/"
xcrun lipo -create \
    "$BUILD_DIR/libboost-simulator-arm64.a" \
    "$BUILD_DIR/libboost-simulator-x86_64.a" \
    -output "$BUILD_DIR/libboost-simulator.a"
mkdir -p "$BUILD_DIR/xcframework-device" "$BUILD_DIR/xcframework-simulator"
cp "$BUILD_DIR/libboost-device-arm64.a" "$BUILD_DIR/xcframework-device/libboost.a"
cp "$BUILD_DIR/libboost-simulator.a" "$BUILD_DIR/xcframework-simulator/libboost.a"
xcodebuild -create-xcframework \
    -library "$BUILD_DIR/xcframework-device/libboost.a" -headers "$PACKAGE_DIR/include" \
    -library "$BUILD_DIR/xcframework-simulator/libboost.a" -headers "$PACKAGE_DIR/include" \
    -output "$PACKAGE_DIR/boost.xcframework"

SOURCE_SHA="$(shasum -a 256 "$SOURCE_ARCHIVE" | awk '{ print $1 }')"
BUILD_TIME="$(date -u '+%Y-%m-%d T%H:%M:%SZ')"
BUILD_NUMBER="${GITHUB_RUN_NUMBER:-1}"
write_pkl() {
    local slice_dir="$1"
    local binary="$2"
    local binary_sha
    binary_sha="$(shasum -a 256 "$slice_dir/$binary" | awk '{ print $1 }')"
    cat > "$slice_dir/boost.pkl" <<EOF
name = "boost"
version = "$BOOST_VERSION"
buildTime = "$BUILD_TIME"
buildNumber = "$BUILD_NUMBER"
type = "ios"
gitUrl = "https://github.com/boostorg/boost"
cppStandard = "${CPPSTD#c++}"
cStandard = ""
linkerFlags = ""
dependencies = ""
binary = "$binary"
binarySha = "$binary_sha"
shaType = "sha256sum"
sourceSHA = "$SOURCE_SHA"
defines = "BOOST_SP_USE_SPINLOCK"
frameworks = ""
includedLibraries = "$BOOST_LIBS"
excludedLibraries = "$EXCLUDED_LIBS"
EOF
}

write_pkl "$PACKAGE_DIR/boost.xcframework/ios-arm64" "libboost.a"
write_pkl "$PACKAGE_DIR/boost.xcframework/ios-arm64_x86_64-simulator" "libboost.a"

write_component_text() {
    local destination="$1"
    {
        echo "Boost $BOOST_VERSION compiled component inventory"
        echo
        echo "Included in this binary:"
        for library in $BOOST_LIBS; do echo "- $library"; done
        echo
        echo "Not included in this binary:"
        while IFS=$'\t' read -r status library note; do
            [[ "$status" == "included" || "$status" == "excluded" ]] || continue
            if [[ " $BOOST_LIBS " != *" $library "* ]]; then
                echo "- $library: $note"
            fi
        done < "$COMPONENT_MANIFEST"
        echo
        echo "All Boost headers are packaged. 'Not included' means that the compiled"
        echo "library is absent from the combined static binary; header-only facilities"
        echo "remain available. See COMPONENTS.md for the release-level inventory."
    } > "$destination"
}

write_component_text "$PACKAGE_DIR/boost.xcframework/ios-arm64/boost-components.txt"
write_component_text "$PACKAGE_DIR/boost.xcframework/ios-arm64_x86_64-simulator/boost-components.txt"

{
    echo "# Boost $BOOST_VERSION component inventory"
    echo
    echo "The XCFramework contains all Boost headers. This inventory describes which"
    echo "libraries contribute compiled objects to the combined static binaries."
    echo
    echo "| Component | Binary status | Notes |"
    echo "| --- | --- | --- |"
    while IFS=$'\t' read -r manifest_status library note; do
        [[ "$manifest_status" == "included" || "$manifest_status" == "excluded" ]] || continue
        if [[ " $BOOST_LIBS " == *" $library "* ]]; then status="Included"; else status="Not included"; fi
        echo "| \`$library\` | $status | $note |"
    done < "$COMPONENT_MANIFEST"
} > "$PACKAGE_DIR/COMPONENTS.md"

RELEASE_NOTES="$REPO_ROOT/packaging/versions/$BOOST_VERSION-release.md"
if [[ -s "$RELEASE_NOTES" ]]; then
    cp "$RELEASE_NOTES" "$PACKAGE_DIR/RELEASE-NOTES.md"
fi
VALIDATION_NOTES="$REPO_ROOT/packaging/versions/$BOOST_VERSION-validation.md"
if [[ -s "$VALIDATION_NOTES" ]]; then
    cp "$VALIDATION_NOTES" "$PACKAGE_DIR/VALIDATION.md"
fi

mkdir -p "$PACKAGE_DIR/cmake/ofxiOSBoost" "$PACKAGE_DIR/pkgconfig"
CMAKE_COMPILE_FEATURE="cxx_std_${CPPSTD#c++}"
sed -e "s|@BOOST_VERSION@|$BOOST_VERSION|g" \
    -e "s|@CMAKE_COMPILE_FEATURE@|$CMAKE_COMPILE_FEATURE|g" \
    "$REPO_ROOT/packaging/cmake/ofxiOSBoostConfig.cmake.in" \
    > "$PACKAGE_DIR/cmake/ofxiOSBoost/ofxiOSBoostConfig.cmake"
sed -e "s|@BOOST_VERSION@|$BOOST_VERSION|g" \
    "$REPO_ROOT/packaging/cmake/ofxiOSBoostConfigVersion.cmake.in" \
    > "$PACKAGE_DIR/cmake/ofxiOSBoost/ofxiOSBoostConfigVersion.cmake"
for pc_template in "$REPO_ROOT"/packaging/pkgconfig/*.pc.in; do
    pc_name="$(basename "$pc_template" .in)"
    sed -e "s|@BOOST_VERSION@|$BOOST_VERSION|g" \
        -e "s|@CPPSTD@|$CPPSTD|g" "$pc_template" \
        > "$PACKAGE_DIR/pkgconfig/$pc_name"
done

cat > "$PACKAGE_DIR/BUILD-INFO.txt" <<EOF
Boost: $BOOST_VERSION
iOS deployment target: $IOS_MIN_VERSION
Architectures: arm64 (device), arm64 and x86_64 (simulator)
Packaging: XCFramework
Metadata: Apothecary PKL, CMake package, pkg-config
C++ standard library: libc++
C++ language standard: $CPPSTD
Libraries: $BOOST_LIBS
Excluded compiled libraries: $EXCLUDED_LIBS
Component inventory: COMPONENTS.md and slice-local boost-components.txt
Release notes: RELEASE-NOTES.md (when supplied for this Boost revision)
Validation: VALIDATION.md (when supplied for this Boost revision)
EOF

(
    cd "$PACKAGE_DIR"
    ditto -c -k --sequesterRsrc --keepParent boost.xcframework \
        "$DIST_DIR/$ARCHIVE_NAME-xcframework.zip"
)

# The main tarball is a ready-to-use addon. Keep the SwiftPM zip minimal, but
# place the framework in the conventional openFrameworks addon location.
ADDON_STAGE="$WORK_DIR/addon-package"
ADDON_ROOT="$ADDON_STAGE/$ARCHIVE_NAME"
mkdir -p "$ADDON_STAGE"
git -C "$REPO_ROOT" archive --prefix="$ARCHIVE_NAME/" HEAD | \
    tar -xf - -C "$ADDON_STAGE"
rm -rf "$ADDON_ROOT/libs/boost/include" "$ADDON_ROOT/libs/boost/ios"
mkdir -p "$ADDON_ROOT/libs/boost/ios"
cp -R "$PACKAGE_DIR/boost.xcframework" "$ADDON_ROOT/libs/boost/ios/"
cp -R "$PACKAGE_DIR/cmake" "$PACKAGE_DIR/pkgconfig" "$ADDON_ROOT/libs/boost/"
cp "$PACKAGE_DIR/LICENSE_1_0.txt" "$PACKAGE_DIR/BUILD-INFO.txt" \
    "$PACKAGE_DIR/COMPONENTS.md" "$ADDON_ROOT/"
for metadata in RELEASE-NOTES.md VALIDATION.md; do
    if [[ -s "$PACKAGE_DIR/$metadata" ]]; then
        cp "$PACKAGE_DIR/$metadata" "$ADDON_ROOT/"
    fi
done
tar -czf "$DIST_DIR/$ARCHIVE_NAME.tar.gz" -C "$ADDON_STAGE" "$ARCHIVE_NAME"

ARCHIVE_SHA="$(shasum -a 256 "$DIST_DIR/$ARCHIVE_NAME.tar.gz" | awk '{ print $1 }')"
sed -e "s|@BOOST_VERSION@|$BOOST_VERSION|g" \
    -e "s|@IOS_MIN_VERSION@|$IOS_MIN_VERSION|g" \
    -e "s|@ARCHIVE_SHA@|$ARCHIVE_SHA|g" \
    "$REPO_ROOT/packaging/cocoapods/ofxiOSBoost.podspec.in" \
    > "$DIST_DIR/ofxiOSBoost.podspec"
(
    cd "$DIST_DIR"
    shasum -a 256 "$ARCHIVE_NAME.tar.gz" > "$ARCHIVE_NAME.tar.gz.sha256"
    shasum -a 256 "$ARCHIVE_NAME-xcframework.zip" > "$ARCHIVE_NAME-xcframework.zip.sha256"
)

if [[ "${GITHUB_ACTIONS:-false}" != "true" ]]; then
    INSTALL_ROOT="$REPO_ROOT/libs/boost"
    INSTALL_FRAMEWORK="$INSTALL_ROOT/ios/boost.xcframework"
    INSTALL_CMAKE="$INSTALL_ROOT/cmake"
    INSTALL_PKGCONFIG="$INSTALL_ROOT/pkgconfig"

    [[ "$INSTALL_FRAMEWORK" == "$REPO_ROOT/libs/boost/ios/boost.xcframework" ]] || exit 1
    [[ "$INSTALL_CMAKE" == "$REPO_ROOT/libs/boost/cmake" ]] || exit 1
    [[ "$INSTALL_PKGCONFIG" == "$REPO_ROOT/libs/boost/pkgconfig" ]] || exit 1
    for install_target in "$INSTALL_FRAMEWORK" "$INSTALL_CMAKE" "$INSTALL_PKGCONFIG"; do
        [[ ! -L "$install_target" ]] || {
            echo "Refusing to replace symbolic link: $install_target" >&2
            exit 1
        }
    done

    mkdir -p "$INSTALL_ROOT/ios"
    rm -rf "$INSTALL_FRAMEWORK" "$INSTALL_CMAKE" "$INSTALL_PKGCONFIG"
    cp -R "$PACKAGE_DIR/boost.xcframework" "$INSTALL_FRAMEWORK"
    cp -R "$PACKAGE_DIR/cmake" "$INSTALL_CMAKE"
    cp -R "$PACKAGE_DIR/pkgconfig" "$INSTALL_PKGCONFIG"
    echo "Installed Boost $BOOST_VERSION at $INSTALL_FRAMEWORK"
fi

echo "Created $DIST_DIR/$ARCHIVE_NAME.tar.gz"
echo "Created $DIST_DIR/ofxiOSBoost.podspec"
echo "Created $DIST_DIR/$ARCHIVE_NAME-xcframework.zip"
