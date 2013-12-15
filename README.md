#ofxiOSBoost for Boost 1.55.0
============

###Boost C++ Libraries 1.55.0 Script to compile boost for iOS
================================================================================
License: See Boost License LICENSE.MD

================================================================================
How to use
================================================================================
- Download files (suggested you download the files to addons/ofxiOSBoost for openFrameworks)
- Double click and run boost.command (this will download the 1.55.0 version of boost and begin compiling the library).
- Once completed in the terminal continue with the next steps.
- Add the ofxiOSBoost to your project (src and libs for your chosen architecture)


How to get working with a project in Xcode?
============

In Xcode Build Settings for your project*:
- Add to Library Search Paths: "$(SRCROOT)/../../../addons/ofxOSXBoost/libs/boost/lib/armv7" **(choose your architecture here)
- Add to Header Search Paths: "$(SRCROOT)/../../../addons/ofxOSXBoost/libs/boost/include"


In Xcode Build Phases
- Add the libs in the addons/ofxiOSBoost/libs/boost/lib/armv7/ directory to Link Binary With Libraries

- Enjoy boost :)

================================================================================
Architectures that will be built in the script for iOS
================================================================================
- arm64 : 1.55.0 built for arm64 (iOS 7 64bit only) [iPhone 5s +]
- armv7s : 1.55.0 built for armv7s (iOS 6+)
- armv7 : Clone of master - (iOS 5, 6, 7+)
- armv6 : 1.55.0 built for armv6 (iOS 4+)

================================================================================
Documentation on Boost 1.55.0
================================================================================

See: http://www.boost.org/users/history/version_1_55_0.html