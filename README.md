#ofxiOSBoost
============

Addon with Boost 1.55.0 for iOS / Xcode - Precompiled and Command to build yourself - Master is currently targeted for armv7 - Check Branches for others - Designed for use as an open frameworks addon, however should definitely work for other iOS projects

Boost C++ Libraries 1.55.0 Pre-compiled for iOS
============
License: See Boost License LICENSE.MD

Where to checkout?
============
- For openframeworks: Checkout in the addons folder like so: addons/ofxiOSBoost
- For others: anywhere you please

How to Build?
============

1. You don't need to. This has the pre-compiled versions of BOOST for you to use
2. If you would prefer to build it yourself checkout the build-yourself branch https://github.com/danoli3/ofxOSXBoost/tree/build-yourself


How to use
=============
- Download files (suggested you download the files to addons/ofxiOSBoost for openFrameworks)

In Xcode Build Settings for your project:
- Add to Library Search Paths: "$(SRCROOT)/../../../addons/ofxiOSBoost/libs/boost/lib/boost/armv7/"
- Add to Header Search Paths: "$(SRCROOT)/../../../addons/ofxiOSBoost/libs/boost/include"


In Xcode Build Phases
- Add the libs in the addons/ofxiOSBoost/libs/boost/lib/boost/armv7/ directory to Link Binary With Libraries

- Enjoy boost :)

================================================================================
Other architectures for iOS
================================================================================
See the other branches on this repository
- arm64 : 1.55.0 built for arm64 (iOS 7 64bit only) [iPhone 5s +]
- armv7s : 1.55.0 built for armv7s (iOS 6+)
- armv7 : Clone of master - (iOS 5, 6, 7+)
- armv6 : 1.55.0 built for armv6 (iOS 4+)

================================================================================
Documentation on Boost 1.55.0
================================================================================

See: http://www.boost.org/users/history/version_1_55_0.html