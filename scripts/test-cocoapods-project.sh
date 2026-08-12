#!/usr/bin/env bash

set -euo pipefail

BOOST_VERSION="${1:-1.70.0}"
[[ "$BOOST_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
    echo "Usage: $0 [BOOST_VERSION]" >&2
    exit 2
}

for command in pod ruby xcodebuild xcrun; do
    command -v "$command" >/dev/null 2>&1 || {
        echo "Required command is not installed: $command" >&2
        exit 1
    }
done
ruby -e 'require "xcodeproj"' 2>/dev/null || {
    echo "The Ruby xcodeproj gem is required." >&2
    exit 1
}

BOOST_MINOR="$(printf '%s' "$BOOST_VERSION" | cut -d. -f2)"
if (( BOOST_MINOR <= 64 )); then
    CPPSTD=c++11
elif (( BOOST_MINOR <= 67 )); then
    CPPSTD=c++14
elif (( BOOST_MINOR <= 79 )); then
    CPPSTD=c++17
else
    CPPSTD=c++20
fi
IPHONEOS_SDK="$(xcrun --sdk iphoneos --show-sdk-path)"
[[ -d "$IPHONEOS_SDK/System/Library/Frameworks/UIKit.framework" ]] || {
    echo "UIKit was not found in the iPhoneOS SDK." >&2
    exit 1
}

TEMP_ROOT="${TMPDIR:-/tmp}"
WORK_DIR="$(mktemp -d "$TEMP_ROOT/ofxiosboost-cocoapods-project.XXXXXX")"
cleanup() {
    [[ -n "$WORK_DIR" && -d "$WORK_DIR" && ! -L "$WORK_DIR" ]] || return
    case "$WORK_DIR" in
        "$TEMP_ROOT"/ofxiosboost-cocoapods-project.*) ;;
        *) return ;;
    esac
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

mkdir -p "$WORK_DIR/cocoapods-home"

cat > "$WORK_DIR/main.mm" <<'EOF'
#import <UIKit/UIKit.h>

#include <boost/filesystem.hpp>
#include <boost/system/error_code.hpp>

int main(int argc, char *argv[])
{
    @autoreleasepool {
        boost::system::error_code error;
        const bool exists = boost::filesystem::exists("/tmp/ofxiosboost", error);
        if (exists || !error) {
            return UIApplicationMain(argc, argv, nil, nil);
        }
        return 1;
    }
}
EOF

cat > "$WORK_DIR/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>org.openframeworks.ofxiOSBoost.CocoaPodsTest</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>UILaunchScreen</key>
    <dict/>
</dict>
</plist>
EOF

WORK_DIR="$WORK_DIR" CPPSTD="$CPPSTD" IPHONEOS_SDK="$IPHONEOS_SDK" ruby <<'RUBY'
require "xcodeproj"

root = ENV.fetch("WORK_DIR")
project = Xcodeproj::Project.new(File.join(root, "CocoaPodsTest.xcodeproj"))
target = project.new_target(:application, "CocoaPodsTest", :ios, "12.0")
source = project.main_group.new_file("main.mm")
target.add_file_references([source])
uikit = project.frameworks_group.new_file(
  File.join(ENV.fetch("IPHONEOS_SDK"), "System/Library/Frameworks/UIKit.framework")
)
target.frameworks_build_phase.add_file_reference(uikit)

target.build_configurations.each do |configuration|
  configuration.build_settings["CLANG_CXX_LANGUAGE_STANDARD"] = ENV.fetch("CPPSTD")
  configuration.build_settings["INFOPLIST_FILE"] = "Info.plist"
  configuration.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "org.openframeworks.ofxiOSBoost.CocoaPodsTest"
  configuration.build_settings["TARGETED_DEVICE_FAMILY"] = "1,2"
end

project.save
RUBY

cat > "$WORK_DIR/Podfile" <<EOF
source 'https://cdn.cocoapods.org/'
platform :ios, '12.0'

target 'CocoaPodsTest' do
  project 'CocoaPodsTest.xcodeproj'
  pod 'ofxiOSBoost', '$BOOST_VERSION'
end
EOF

echo "Installing ofxiOSBoost $BOOST_VERSION into a clean UIKit project"
install_log="$WORK_DIR/pod-install.log"
if ! (
    cd "$WORK_DIR"
    CP_HOME_DIR="$WORK_DIR/cocoapods-home" \
        pod install --repo-update --no-ansi >"$install_log" 2>&1
); then
    tail -n 80 "$install_log"
    exit 1
fi

grep -Fq "ofxiOSBoost ($BOOST_VERSION)" "$WORK_DIR/Podfile.lock" || {
    echo "Podfile.lock does not contain ofxiOSBoost $BOOST_VERSION." >&2
    exit 1
}

echo "Compiling and linking the CocoaPods workspace for iOS Simulator"
build_log="$WORK_DIR/xcodebuild.log"
if ! xcodebuild \
    -workspace "$WORK_DIR/CocoaPodsTest.xcworkspace" \
    -scheme CocoaPodsTest \
    -configuration Release \
    -sdk iphonesimulator \
    -destination 'generic/platform=iOS Simulator' \
    -derivedDataPath "$WORK_DIR/DerivedData" \
    CODE_SIGNING_ALLOWED=NO \
    build >"$build_log" 2>&1; then
    if ! grep -A20 -B10 'error:' "$build_log" | tail -n 120; then
        tail -n 80 "$build_log"
    fi
    exit 1
fi

APP="$WORK_DIR/DerivedData/Build/Products/Release-iphonesimulator/CocoaPodsTest.app"
[[ -d "$APP" && -x "$APP/CocoaPodsTest" ]] || {
    echo "Xcode reported success, but the application was not produced." >&2
    exit 1
}

echo "PASS: CocoaPods $BOOST_VERSION consumer project compiled and linked successfully."
