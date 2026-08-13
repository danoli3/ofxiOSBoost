# ofxiOSBoost
--------------------

![image](https://github.com/danoli3/ofxiOSBoost/blob/master/ofxaddons_thumbnail.png)

Boost is a large, peer-reviewed collection of portable C++ libraries that both
  fills gaps in the standard library and serves as a proving ground for features—many of which (like smart
  pointers, regex, and filesystem) later get adopted into the C++ standard itself

### Current release targets

Starting with Boost 1.61.0, releases are packaged as static XCFrameworks using
libc++. Current release builds contain:

- `arm64`: iOS devices
- `arm64`: iOS Simulator on Apple Silicon
- `x86_64`: iOS Simulator on Intel Macs

### Release build matrix

Badges below show the current `master` workflow status. Each row keeps its
version-specific badge label while sharing the same workflow status and link.
The tagged workflow builds the XCFramework, installs the consolidated example
on an iOS Simulator, runs its smoke suite, and requires `ALL TESTS PASSED`
before publishing release assets. The captured report is included in the
GitHub Actions job summary.

The same build and Simulator smoke suite runs on every push to `master` using
the newest supported Boost version. Master runs upload workflow artifacts but
do not create or modify GitHub Releases.

| Boost | C++ | GitHub Actions | Release |
| --- | --- | --- | --- |
| [1.75.0](https://www.boost.org/users/history/version_1_75_0.html) | C++17 | [![Boost 1.75.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.75.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.75.0) |
| [1.74.0](https://www.boost.org/users/history/version_1_74_0.html) | C++17 | [![Boost 1.74.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.74.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.74.0) |
| [1.73.0](https://www.boost.org/users/history/version_1_73_0.html) | C++17 | [![Boost 1.73.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.73.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.73.0) |
| [1.72.0](https://www.boost.org/users/history/version_1_72_0.html) | C++17 | [![Boost 1.72.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.72.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.72.0) |
| [1.71.0](https://www.boost.org/users/history/version_1_71_0.html) | C++17 | [![Boost 1.71.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.71.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.71.0) |
| [1.70.0](https://www.boost.org/users/history/version_1_70_0.html) | C++17 | [![Boost 1.70.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.70.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.70.0) |
| [1.69.0](https://www.boost.org/users/history/version_1_69_0.html) | C++17 | [![Boost 1.69.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.69.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.69.0) |
| [1.68.0](https://www.boost.org/users/history/version_1_68_0.html) | C++17 | [![Boost 1.68.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.68.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.68.0) |
| [1.67.0](https://www.boost.org/users/history/version_1_67_0.html) | C++14 | [![Boost 1.67.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.67.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.67.0) |
| [1.66.0](https://www.boost.org/users/history/version_1_66_0.html) | C++14 | [![Boost 1.66.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.66.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.66.0) |
| [1.65.0](https://www.boost.org/users/history/version_1_65_0.html) | C++14 | [![Boost 1.65.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.65.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.65.0) |
| [1.64.0](https://www.boost.org/users/history/version_1_64_0.html) | C++11 | [![Boost 1.64.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.64.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.64.0) |
| [1.63.0](https://www.boost.org/users/history/version_1_63_0.html) | C++11 | [![Boost 1.63.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.63.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.63.0) |
| [1.62.0](https://www.boost.org/users/history/version_1_62_0.html) | C++11 | [![Boost 1.62.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.62.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.62.0) |
| [1.61.0](https://www.boost.org/users/history/version_1_61_0.html) | C++11 | [![Boost 1.61.0 build](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml/badge.svg)](https://github.com/danoli3/ofxiOSBoost/actions/workflows/release-boost.yml) | [Boost 1.61.0](https://github.com/danoli3/ofxiOSBoost/releases/tag/1.61.0) |

Boost 1.65.0 adds compiled Boost.Context. Its arm64 AAPCS Mach-O device
implementation and Simulator implementations were runtime-tested with real
`jump_fcontext` transfers and direct `ontop_fcontext` execution. The header-only
Boost.Coroutine2 API was tested on top of the same binary by yielding and
resuming values. The full packaged-library smoke suite passed on an arm64 iOS
Simulator and a physical arm64 iOS device.

Boost.Fiber and the deprecated compiled Boost.Coroutine library are not part of
the 1.65.0 binary. They are separate compiled dependents of Boost.Context and
require their own runtime coverage before inclusion.

Boost 1.66.0 carries forward the same compiled Context configuration and adds
the new header-only Boost.Beast, Boost.CallableTraits, and Boost.Mp11 headers.
The consolidated app smoke-tests those libraries without network access. The
full consolidated suite passed on an arm64 Simulator and a physical arm64
iOS device.

Boost 1.67.0 remains on C++14, carries forward the validated compiled Context
configuration, and adds smoke coverage for the new Boost.Contract and Boost.HOF
libraries. Contract uses its header-only mode; its optional compiled library
remains excluded pending dedicated runtime evaluation. C++17 begins at 1.68.0.

Boost 1.68.0 moves to C++17, retains the validated Context and Coroutine2
configuration, and adds smoke coverage for the new header-only Boost.YAP
expression-template library. Fiber and deprecated compiled Coroutine remain
excluded pending dedicated device and Simulator runtime evaluation. The full
suite passed on an arm64 Simulator and physical arm64 iOS device.

Boost 1.69.0 remains on C++17 and carries forward Context and Coroutine2.
Boost.SafeNumerics is new and its headers are included, but its 1.69
`safe_compare` implementation is rejected by current Apple Clang, so runtime
coverage is deferred to a later fixed release. Legacy compiled Boost.Signals
was removed upstream, so the smoke suite moves to header-only Boost.Signals2.

Boost 1.70.0 remains on C++17, retains the nine compiled libraries plus
Context, and adds smoke coverage for the new header-only Boost.Histogram and
Boost.Outcome libraries. The complete suite passed on an arm64 iOS Simulator
and physical arm64 iOS device.

Boost 1.71.0 remains on C++17, carries forward the validated compiled-library
configuration, and adds smoke coverage for the new header-only Boost.Variant2
library. The complete suite passed on a physical arm64 iOS device; Simulator
runtime confirmation remains pending.

Boost 1.72.0 remains on C++17 and introduces no new library. It updates the
existing collection; the smoke suite adds coverage for Boost.Filesystem's newly
compiled `filesystem_error` implementation. The complete suite passed on an
arm64 iOS Simulator and physical arm64 iOS device.

Boost 1.73.0 remains on C++17 and adds Boost.StaticString plus Boost.Nowide.
StaticString operations, portable Nowide UTF conversion, and Variant2's new
hash support are smoke-tested. The compiled Nowide library is included and its
`fopen` adapter is exercised on both Simulator and physical device. The complete
consolidated suite passed on an arm64 iOS Simulator and physical arm64 device.

Boost 1.74.0 remains on C++17 and adds the header-only Boost.STLInterfaces.
The smoke suite covers its CRTP random-access iterator, Nowide generic UTF
conversion, Variant2 `visit<R>` with a derived variant, Filesystem copy options,
and Asio's offline executor model. Simulator and device runtime confirmation is
complete; the consolidated suite passed on an arm64 iOS Simulator and physical
arm64 iOS device.

Boost 1.75.0 remains on C++17 and adds compiled Boost.JSON and
Boost.Serialization plus header-only Boost.LEAF and Boost.PFR coverage.
The complete suite passed on an arm64 iOS Simulator and physical arm64 iOS
device.

Install the pinned release expected by this checkout:

```sh
./scripts/install-boost.sh
```

To explicitly follow the newest published release instead:

```sh
./scripts/install-boost.sh latest
```

The pinned form is recommended for reproducible openFrameworks projects. The
installer verifies the published checksum and places the ignored dependency at
`libs/boost/ios/boost.xcframework`. openFrameworks has no universal addon dependency
package manager; an addon setup script combined with `addon_config.mk` is the
usual repository-level approach.

#### CocoaPods

Add the versioned pod to your application's `Podfile`:

```ruby
platform :ios, '12.0'

target 'YourApp' do
  pod 'ofxiOSBoost', '1.75.0'
end
```

Install it and open the generated workspace:

```sh
pod install
open YourApp.xcworkspace
```

#### Swift Package Manager

From an existing Swift package directory, add the exact release and attach its
`ofxiOSBoost` product to your target:

```sh
swift package add-dependency \
  https://github.com/danoli3/ofxiOSBoost.git --exact 1.75.0
swift package add-target-dependency \
  ofxiOSBoost YourTarget --package ofxiosboost
```

In Xcode, use **File → Add Package Dependencies**, enter the repository URL,
select version `1.75.0`, and add the `ofxiOSBoost` product to the application
target.

Each GitHub Release provides two package archives:

- `ofxiOSBoost-VERSION.tar.gz` is the complete ready-to-drop openFrameworks
  addon, with its XCFramework installed at
  `libs/boost/ios/boost.xcframework` and matching build metadata included.
- `ofxiOSBoost.podspec` is generated from the same binary archive,
  validated by the release workflow, and published to CocoaPods Trunk when the
  repository has a `COCOAPODS_TRUNK_TOKEN` secret configured.
- `ofxiOSBoost-VERSION-xcframework.zip` places the XCFramework at the archive
  root for use as a Swift Package Manager binary target. Its checksum is
  published beside it.

The root-level podspec was removed because it described only the historical
Boost 1.60.0 directory layout. CocoaPods 1.9 or newer can consume the generated
release podspec through its vendored-XCFramework support. GitHub Releases remain
the authoritative binary source; the podspec pins the release archive SHA-256.

`example-swift-package` contains both a minimal C++ executable package and a
Swift UIKit Xcode app. A small C-compatible C++ bridge lets the Swift app run
the Boost.Filesystem, Boost.Regex, and version-appropriate header-only tests.
The build script stages the release XCFramework as a local binary target and
builds both examples for arm64 and x86_64 iOS Simulator.

The repository root is also an Apple Swift package. After the matching semantic
release tag is published, add the following package URL in Xcode:

```text
https://github.com/danoli3/ofxiOSBoost.git
```

Swift applications should depend on the `ofxiOSBoost` product, which uses a
C-compatible bridge and does not require Swift C++ interoperability. C++ Swift
package targets may depend on the lower-level `boost` product directly.

Build and verify the example from a local release archive with:

```sh
BOOST_VERSION=1.75.0 ./example-swift-package/build.sh \
  dist/ofxiOSBoost-1.75.0.tar.gz
```

To use the app interactively, copy `boost.xcframework` from the release archive
to `example-swift-package/Package/`, then open
`example-swift-package/BoostSwiftExample.xcodeproj`. The Xcode target consumes
the local Swift package product `ofxiOSBoostBridge`; Swift does not import the
C++ Boost headers directly.

Release packages include metadata for additional build systems:

- `boost.pkl` beside each XCFramework library follows the openFrameworks
  Apothecary metadata convention and records the exact slice checksum plus the
  included and excluded compiled-library lists.
- `boost-components.txt` beside each slice binary provides a plain-text
  inventory, while the package-level `COMPONENTS.md` explains every included
  and omitted compiled component. All Boost headers remain present, including
  those belonging to header-only libraries.
- `cmake/ofxiOSBoost` provides the imported target `ofxiOSBoost::boost` and
  selects the device or Simulator slice from `CMAKE_OSX_SYSROOT`.
- `pkgconfig/ofxiOSBoost-ios.pc` and
  `pkgconfig/ofxiOSBoost-ios-simulator.pc` expose device and Simulator metadata
  separately because pkg-config cannot select XCFramework slices dynamically.

### C++ standard by Boost version

The release build selects a C++ language standard appropriate for each Boost
generation. This policy applies to both device and Simulator libraries:

| Boost versions | Build standard | Rationale |
| --- | --- | --- |
| 1.61.0–1.64.x | C++11 | Conservative baseline for these older releases |
| 1.65.0–1.67.x | C++14 | Conservative compatibility through Boost 1.67 |
| 1.68.0–1.79.x | C++17 | Boost libraries increasingly added and tested C++17 support |
| 1.80.0 and newer | C++20 | Later releases include broader C++20 compatibility fixes |


### About

- Boost C++ libraries precompiled for iOS and Xcode
- Precompiled releases and a command to build them yourself
- Designed for use as an [openFrameworks](https://github.com/openframeworks/openFrameworks) addon, while also supporting other iOS projects
- Built with clang++ and libc++, using the versioned C++ standard policy above
- License: See Boost License [LICENSE.MD](https://github.com/danoli3/ofxiOSBoost/blob/master/LICENSE.md)


============

### How To Link to an Xcode Project?

Run `./scripts/install-boost.sh` before generating or opening the project. New
projects should link `libs/boost/ios/boost.xcframework`; Xcode then selects the
correct device or Simulator library automatically.

In Xcode **Build Settings** for your project:

- Link `libs/boost/ios/boost.xcframework` in **Frameworks, Libraries, and
  Embedded Content** (or **Link Binary With Libraries** in older Xcode).
- If a header search path is required by a legacy target, use the matching
  slice headers at
  `libs/boost/ios/boost.xcframework/ios-arm64/Headers` (device) or
  `libs/boost/ios/boost.xcframework/ios-arm64_x86_64-simulator/Headers`
  (Simulator).

In Xcode for a **Build Target** select the **Target under Build Phases**

The old `libs/boost/include` and `libs/boost/lib/ios` paths belonged to the
pre-XCFramework Boost 1.60 layout and are no longer generated.

### Versioned binary releases

New Boost builds are distributed as GitHub Release assets instead of being added
to the repository. The first automated release is Boost 1.61.0. Its archive
contains the Boost headers and a libc++ static XCFramework for arm64 iOS devices
and arm64/x86_64 iOS Simulator.

Maintainers can create or refresh the current release by running the **Build and
release Boost for iOS** workflow with version `1.75.0`. Pushing the tag
`1.75.0` runs the same workflow. The workflow publishes both the archive
and its SHA-256 checksum to the matching GitHub Release.

To build the same package locally with a current Xcode installation:

```sh
BOOST_VERSION=1.75.0 ./scripts/build-boost-ios.sh
```

The generated files are placed in `dist/`, which is intentionally ignored by
Git.

### XCFramework example

`example-xcframework` verifies a release independently of openFrameworks. It
checks the XCFramework metadata and device/Simulator slices, then compiles and
links the packaged libraries for arm64 iOS devices and arm64/x86_64 iOS
Simulator. The Xcode application runs the consolidated Boost smoke suite,
including version-appropriate Context, Coroutine2, Asio, and header-only tests.

The default command downloads and tests the current supported release:

```sh
./example-xcframework/build.sh
```

To test a locally built archive instead, pass its path explicitly:

```sh
./example-xcframework/build.sh dist/ofxiOSBoost-1.75.0.tar.gz
```

For interactive Simulator or physical-device runtime testing, install or copy
that release to `libs/boost/ios/boost.xcframework`, then open
`example-xcframework/ofxiOSBoostContextExample.xcodeproj` in Xcode and run the
application.

### For tvOS - Checkout the ofxtvOSBoost repo:
- https://github.com/danoli3/ofxtvOSBoost

============

### How to Build?

1. You don't need to. This has the pre-compiled versions of BOOST for you to use
2. If you would prefer to build it yourself checkout the script included in the ``` scripts ``` directory.


#### Current Boost release documentation

[Boost 1.75.0 upstream release history](https://www.boost.org/users/history/version_1_75_0.html)

### Version 1.75.0 — December 11, 2020

Boost 1.75.0 adds compiled Boost.JSON and Boost.Serialization plus header-only
Boost.LEAF and Boost.PFR coverage. The complete runtime suite passed on an arm64
iOS Simulator and physical arm64 iOS device.

[Boost 1.74.0 upstream release history](https://www.boost.org/users/history/version_1_74_0.html)

### Version 1.74.0 — August 14, 2020

Boost 1.74.0 remains on C++17. It adds Boost.STLInterfaces and carries forward
compiled Context and Nowide plus header-only Coroutine2. Device and Simulator
runtime tests passed on arm64.

[Boost 1.73.0 upstream release history](https://www.boost.org/users/history/version_1_73_0.html)

### Version 1.73.0 — April 28, 2020

Boost 1.73.0 remains on C++17. It adds Boost.StaticString and Boost.Nowide,
retains compiled Context and header-only Coroutine2, and includes the complete
Boost header tree. Its complete runtime suite passed on an arm64 iOS Simulator
and physical arm64 iOS device.

[Boost 1.72.0 upstream release history](https://www.boost.org/users/history/version_1_72_0.html)

### Version 1.72.0 — December 11, 2019

Boost 1.72.0 remains on C++17 and introduces no new library. It updates the
existing collection, retains compiled Context and header-only Coroutine2, and
includes the complete Boost header tree.

[Boost 1.71.0 upstream release history](https://www.boost.org/users/history/version_1_71_0.html)

### Version 1.71.0 — August 19, 2019

Boost 1.71.0 remains on C++17. It adds the header-only Boost.Variant2 library,
retains compiled Context and header-only Coroutine2, and includes the complete
Boost header tree.

[Boost 1.70.0 upstream release history](https://www.boost.org/users/history/version_1_70_0.html)

### Version 1.70.0 — April 12, 2019

Boost 1.70.0 remains on C++17. It adds the header-only Boost.Histogram and
Boost.Outcome libraries, retains compiled Context and header-only Coroutine2,
and includes the complete Boost header tree.

### Version 1.69.0 — December 12, 2018

Boost 1.69.0 remains on C++17. It includes the new Boost.SafeNumerics headers
but defers runtime coverage due to current Apple Clang incompatibility, and
carries forward compiled Context, Coroutine2, and the complete header tree.

### Version 1.68.0 — August 9, 2018

Boost 1.68.0 moves to C++17. It adds the header-only Boost.YAP expression
template library, carries forward compiled Context and header-only Coroutine2,
and includes their 1.68 maintenance fixes.

### Version 1.67.0 — April 11, 2018

Boost 1.67.0 remains on C++14. It adds Boost.Contract and Boost.HOF, retains the
compiled Context and header-only Coroutine2 coverage, and includes the complete
updated Boost header tree. The package moves to C++17 with Boost 1.68.0.

### Version 1.66.0 — December 18, 2017

============

### Troubleshooting

#### Undefined UIKit or CoreGraphics symbols

Errors such as these mean the application target is not linking the required
iOS system frameworks:

```text
Undefined symbol: _CGRectZero
Undefined symbol: _OBJC_CLASS_$_UIColor
Undefined symbol: _OBJC_CLASS_$_UIFont
Undefined symbol: _OBJC_CLASS_$_UIResponder
Undefined symbol: _OBJC_CLASS_$_UIScreen
Undefined symbol: _OBJC_CLASS_$_UITextView
Undefined symbol: _OBJC_CLASS_$_UIViewController
Undefined symbol: _OBJC_CLASS_$_UIWindow
Undefined symbol: _OBJC_METACLASS_$_UIResponder
Undefined symbol: _UIApplicationMain
Undefined symbol: _UIFontWeightRegular
```

In the iOS application target, open **Build Phases → Link Binary With
Libraries** and add:

- `UIKit.framework`
- `CoreGraphics.framework`

Make sure these are the iOS SDK frameworks, not macOS frameworks.

#### Undefined iconv symbols

Boost.Locale may produce these errors when the system iconv library is absent:

```text
Undefined symbol: _iconv
Undefined symbol: _iconv_close
Undefined symbol: _iconv_open
```

In **Build Phases → Link Binary With Libraries**, add `libiconv.tbd` from the
iOS SDK.

#### Undefined Boost.Context symbols

```text
Undefined symbol: boost::context::stack_traits::default_size()
Undefined symbol: _jump_fcontext
Undefined symbol: _make_fcontext
Undefined symbol: _ontop_fcontext
```

Use a Boost 1.65.0 or newer ofxiOSBoost XCFramework, where Context is included,
and confirm `boost.xcframework` is linked by the application target.

#### C++ standard-library mismatch

Older projects may report unresolved `std::__1` symbols, particularly when
using compiled libraries such as Serialization:

```text
Undefined symbols for architecture i386:
"std::__1::__vector_base_common<true>::__throw_length_error() const"
```

Set the target's **C++ Standard Library** to `libc++`. Set **C++ Language
Dialect** to the standard required by the selected release: C++11 through Boost
1.64, or C++14 for Boost 1.65–1.66.

### Parse errors when including `boost/type_traits.hpp`
If you happen to include `<boost/type_traits.hpp>` header file, you may see compile errors like this

    Unexpected member name of ';' after declaration specifiers

To fix this problem, include the following line in your porject `***-Prefix.pch` file.

    #define __ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES 0

============

### Legacy Boost 1.60.0 fat-library architectures

The original checked-in Boost 1.60.0 release used a fat static library rather
than an XCFramework. These slices are retained only as documentation for that
legacy release and are not targets of the current release workflow. See the
historical branches for the original libc++/C++11 variants.

- ```arm64``` : (iOS 7, 8, 9 64bit only) [iPhone 5S, iPhone 6/6S, iPhone 6/6S Plus, iPad Air /2, iPad Mini Retina 1/2/3/4,  iPad Pro]
- ```armv7``` : (iOS 5, 6, 7, 8, 9) [All devices]
- ```i386``` : (iOS Simulator iPad 2, 3, 4, iPhone 4S, 5, 5C)
- ```x86_64```: (iOS Simulator iPad Air, iPhone 5S, iPhone 6/6S, iPhone 6/6S Plus)

The legacy release did not include armv7s.

============
