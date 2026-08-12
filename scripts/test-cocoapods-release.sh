#!/usr/bin/env bash

set -euo pipefail

BOOST_VERSION="${1:-1.70.0}"
[[ "$BOOST_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
    echo "Usage: $0 [BOOST_VERSION]" >&2
    exit 2
}

command -v pod >/dev/null 2>&1 || {
    echo "CocoaPods is not installed." >&2
    exit 1
}

TEMP_ROOT="${TMPDIR:-/tmp}"
WORK_DIR="$(mktemp -d "$TEMP_ROOT/ofxiosboost-cocoapods.XXXXXX")"
cleanup() {
    [[ -n "$WORK_DIR" && -d "$WORK_DIR" && ! -L "$WORK_DIR" ]] || return
    case "$WORK_DIR" in
        "$TEMP_ROOT"/ofxiosboost-cocoapods.*) ;;
        *) return ;;
    esac
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

mkdir -p "$WORK_DIR/cocoapods-home"

cat > "$WORK_DIR/Podfile" <<EOF
source 'https://cdn.cocoapods.org/'
platform :ios, '12.0'
install! 'cocoapods', :integrate_targets => false

abstract_target 'DownloadTest' do
  pod 'ofxiOSBoost', '$BOOST_VERSION'
end
EOF

echo "Downloading ofxiOSBoost $BOOST_VERSION through the public CocoaPods CDN"
if ! (
    cd "$WORK_DIR"
    CP_HOME_DIR="$WORK_DIR/cocoapods-home" pod install --repo-update --no-ansi
); then
    echo "CocoaPods could not install ofxiOSBoost $BOOST_VERSION." >&2
    exit 1
fi

XCFRAMEWORK="$(find "$WORK_DIR/Pods" -type d -name boost.xcframework -print -quit)"
[[ -n "$XCFRAMEWORK" && -f "$XCFRAMEWORK/Info.plist" ]] || {
    echo "The pod installed, but boost.xcframework was not found." >&2
    exit 1
}

plutil -lint "$XCFRAMEWORK/Info.plist" >/dev/null
grep -Fq "ofxiOSBoost ($BOOST_VERSION)" "$WORK_DIR/Podfile.lock" || {
    echo "Podfile.lock does not contain ofxiOSBoost $BOOST_VERSION." >&2
    exit 1
}

echo "PASS: CocoaPods downloaded ofxiOSBoost $BOOST_VERSION and validated boost.xcframework."
