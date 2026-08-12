#!/usr/bin/env bash

set -euo pipefail

REQUESTED_VERSION="${1:-1.71.0}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_ROOT="$REPO_ROOT/libs/boost"
TARGET="$INSTALL_ROOT/ios/boost.xcframework"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ofxiosboost-install.XXXXXX")"

cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

if [[ "$REQUESTED_VERSION" == "latest" ]]; then
    echo "Resolving latest GitHub Release"
    release_url="$(curl --fail --location --silent --show-error \
        --output /dev/null --write-out '%{url_effective}' \
        https://github.com/danoli3/ofxiOSBoost/releases/latest)"
    release_tag="${release_url##*/}"
    BOOST_VERSION="$release_tag"
    [[ "$release_tag" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
        echo "Could not determine the latest Boost release tag." >&2
        exit 1
    }
else
    BOOST_VERSION="$REQUESTED_VERSION"
    release_tag="$BOOST_VERSION"
fi

ASSET="ofxiOSBoost-${BOOST_VERSION}.tar.gz"
RELEASE_ROOT="https://github.com/danoli3/ofxiOSBoost/releases/download/$release_tag"

echo "Downloading $release_tag"
curl --fail --location --retry 3 "$RELEASE_ROOT/$ASSET" --output "$WORK_DIR/$ASSET"
curl --fail --location --retry 3 "$RELEASE_ROOT/$ASSET.sha256" --output "$WORK_DIR/$ASSET.sha256"

expected_hash="$(awk 'NR == 1 { print $1 }' "$WORK_DIR/$ASSET.sha256")"
actual_hash="$(shasum -a 256 "$WORK_DIR/$ASSET" | awk '{ print $1 }')"
[[ "$actual_hash" == "$expected_hash" ]] || {
    echo "Release checksum does not match." >&2
    exit 1
}

tar -xzf "$WORK_DIR/$ASSET" -C "$WORK_DIR"
SOURCE="$WORK_DIR/ofxiOSBoost-${BOOST_VERSION}/libs/boost/ios/boost.xcframework"
plutil -lint "$SOURCE/Info.plist" >/dev/null

mkdir -p "$INSTALL_ROOT/ios"
if [[ -e "$TARGET" ]]; then
    [[ "$TARGET" == "$REPO_ROOT/libs/boost/ios/boost.xcframework" ]] || exit 1
    rm -rf "$TARGET"
fi
cp -R "$SOURCE" "$TARGET"
rm -rf "$INSTALL_ROOT/cmake" "$INSTALL_ROOT/pkgconfig"
cp -R "$WORK_DIR/ofxiOSBoost-${BOOST_VERSION}/libs/boost/cmake" "$INSTALL_ROOT/"
cp -R "$WORK_DIR/ofxiOSBoost-${BOOST_VERSION}/libs/boost/pkgconfig" "$INSTALL_ROOT/"

echo "Installed Boost $BOOST_VERSION at $TARGET"
