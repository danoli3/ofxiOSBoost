#ofxiOSBoost for Boost 1.59.0  ![image](https://travis-ci.org/danoli3/ofxiOSBoost.svg?branch=master)
=====================================


### Boost C++ Libraries 1.59.0 Pre-compiled for iOS
![image](https://github.com/danoli3/ofxiOSBoost/blob/master/ofxaddons_thumbnail.png)

- Addon with Boost 1.59.0 for iOS / Xcode 
- Precompiled library and Command to build yourself
- Master is currently a Fat Lib of All Standard Architectures
- Check Branches for others or to be specific 
- Designed for use as an open frameworks addon, however should definitely work for other iOS projects
- Built with clang++ and using libc++ and std=c++11
- License: See Boost License [LICENSE.MD](https://github.com/danoli3/ofxiOSBoost/blob/master/LICENSE.md)

============


### Where to checkout?

- For openframeworks: Checkout in the addons folder like so: addons/ofxiOSBoost
- For others: anywhere you please



============

### How To Link to an Xcode Project?

In Xcode **Build Settings** for your project:

- Add to **Library Search Paths** ( ```LIBRARY_SEARCH_PATHS``` ) ```$(SRCROOT)/../../../addons/ofxiOSBoost/libs/boost/lib/ios ```
- Add to **Header Search Paths** ( ```HEADER_SEARCH_PATHS``` )  
```$(SRCROOT)/../../../addons/ofxiOSBoost/libs/boost/include ```

In Xcode for a **Build Target** select the **Target under Build Phases**

- Add to **'Link Binary With Libraries'** the ```boost.a``` found in the ```ofxiOSBoost/libs/boost/lib/ios``` directory.

If not openFrameworks just add the ``` libs/boost/include ``` to Header Search Paths and the  ``` libs/boost/ios ``` to Library Search Paths



============

### Architectures in Pre-Build Library (Fat Lib)
See the other branches on this repository (All libc++ std=c11)

- ```arm64``` : (iOS 7, 8, 9 64bit only) [iPhone 5S, iPhone 6/6S, iPhone 6/6S Plus, iPad Air /2, iPad Mini Retina 1/2/3/4,  iPad Pro]
- ```armv7``` : (iOS 5, 6, 7, 8, 9) [All devices]
- ```i386``` : (iOS Simulator iPad 2, 3, 4, iPhone 4S, 5, 5C)
- ```x86_64```: (iOS Simulator iPad Air, iPhone 5S, iPhone 6/6S, iPhone 6/6S Plus)

Check Apple's Hardware sheet if you need to verify: [Apple's Device compatibilty Matrix](https://developer.apple.com/library/ios/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/DeviceCompatibilityMatrix/DeviceCompatibilityMatrix.html)

** Armv7s has been removed due to Apple phasing our the requirement from the STANDARD_ARCHITECTURES.

============

### How to Build?

1. You don't need to. This has the pre-compiled versions of BOOST for you to use
2. If you would prefer to build it yourself checkout the script included in the ``` scripts ``` directory.


=============

### How to use Build Script


- Download files (suggested you download the files to addons/ofxiOSBoost for openFrameworks)
- Double click and run ```scripts/build-libc++.command``` (this will download the 1.59.0 version of boost and begin compiling the library).
- Once completed in the terminal continue with the next steps.
- Add the ofxiOSBoost to your project (src and libs for your chosen architecture)`

#### Alternative Build Script:
- Build using libstdc++ by running the ```scripts/build-libstdc++.command```

#### Clean script
- Run the clean script from ```scripts/cleanAll.command``` to remove pre-compiled code and the final built library


============

#### Documentation on Boost 1.59.0


See: http://www.boost.org/users/history/version_1_59_0.html


### Version 1.59.0 (Date): August 13th, 2015

============



### Troubleshooting:

### Undefined symbols link error (For libc++ release)
If you use libraries like `serialization` you might see link errors in Xcode 6 especially when the framework was built using `--with-c++11` flag.
```
    Undefined symbols for architecture i386:
    "std::__1::__vector_base_common<true>::__throw_length_error() const", referenced from:
    void std::__1::vector<boost::archive::detail::basic_iarchive_impl::cobject_id, std::__1::allocator<boost::archive::detail::basic_iarchive_impl::cobject_id> >::__push_back_slow_path<boost::archive::detail::basic_iarchive_impl::cobject_id>(boost::archive::detail::basic_iarchive_impl::cobject_id&&) in boost(libboost_serialization_basic_iarchive.o)
```

You have to change your project or target build settings.

Under *Apple LLVM 6.0 - Language - C++* make the following changes

```C++ Language Dialect``` to ```C++11 [-std=c++11]```
```C++ Standard Library``` to ```libc++ (LLVM C++ standard library with C++11 support)```

### Parse errors when including `boost/type_traits.hpp`
If you happen to include `<boost/type_traits.hpp>` header file, you may see compile errors like this

    Unexpected member name of ';' after declaration specifiers

To fix this problem, include the following line in your porject `***-Prefix.pch` file.

    #define __ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES 0


