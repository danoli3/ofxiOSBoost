# ofxiOSBoost
--------------------

![image](https://github.com/danoli3/ofxiOSBoost/blob/master/ofxaddons_thumbnail.png)

### Current release targets

Starting with Boost 1.61.0, releases are packaged as static XCFrameworks using
libc++. Current release builds contain:

- `arm64`: iOS devices
- `arm64`: iOS Simulator on Apple Silicon
- `x86_64`: iOS Simulator on Intel Macs

Current releases do not contain `armv7` or `i386` slices. Download the
versioned XCFramework and its SHA-256 checksum from GitHub Releases.

### C++ standard by Boost version

The release build selects a C++ language standard appropriate for each Boost
generation. This policy applies to both device and Simulator libraries:

| Boost versions | Build standard | Rationale |
| --- | --- | --- |
| 1.61.0–1.64.x | C++11 | Conservative baseline for these older releases |
| 1.65.0–1.66.x | C++14 | Uses the newer standard while retaining broad compatibility |
| 1.67.0–1.79.x | C++17 | Boost libraries increasingly added and tested C++17 support |
| 1.80.0 and newer | C++20 | Later releases include broader C++20 compatibility fixes |

There is no C++21 language standard; C++20 is followed by C++23. We retain
C++20 for the newest Boost packages until the selected compiled libraries and
their public headers are verified together under C++23. The selected default
can be overridden locally with `CPPSTD`, for example `CPPSTD=c++17`, but release
artifacts use the table above.


### About

- Boost C++ libraries precompiled for iOS and Xcode
- Precompiled releases and a command to build them yourself
- Designed for use as an open frameworks addon, however should definitely work for other iOS projects
- Built with clang++ and libc++, using the versioned C++ standard policy above
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

- Add to **'Link Binary With Libraries'** the ```libboost.a``` found in the ```ofxiOSBoost/libs/boost/lib/ios``` directory.

If not openFrameworks just add the ``` libs/boost/include ``` to Header Search Paths and the  ``` libs/boost/ios ``` to Library Search Paths

### Versioned binary releases

New Boost builds are distributed as GitHub Release assets instead of being added
to the repository. The first automated release is Boost 1.61.0. Its archive
contains the Boost headers and a libc++ static XCFramework for arm64 iOS devices
and arm64/x86_64 iOS Simulator.

Maintainers can create or refresh the release by running the **Build and release
Boost for iOS** workflow with version `1.61.0`. Pushing the tag
`boost-1.61.0` runs the same workflow. The workflow publishes both the archive
and its SHA-256 checksum to the `boost-1.61.0` GitHub Release.

To build the same package locally with a current Xcode installation:

```sh
BOOST_VERSION=1.61.0 ./scripts/build-boost-ios
```

The generated files are placed in `dist/`, which is intentionally ignored by
Git.



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


### For tvOS - Checkout the ofxtvOSBoost repo:
- https://github.com/danoli3/ofxtvOSBoost

============

### How to Build?

1. You don't need to. This has the pre-compiled versions of BOOST for you to use
2. If you would prefer to build it yourself checkout the script included in the ``` scripts ``` directory.


=============

### How to use Build Script


- Download files (suggested you download the files to addons/ofxiOSBoost for openFrameworks)
- Double click and run ```scripts/build-libc++``` (this will download the 1.60.0 version of boost and begin compiling the library).
- Once completed in the terminal continue with the next steps.
- Add the ofxiOSBoost to your project (src and libs for your chosen architecture)`

#### Build with Bitcode Embedded:
- Build with embedded bitcode by running the ```scripts/build-libc++withBitcode```


#### Alternative Build Script:
- Build using libstdc++ by running the ```scripts/build-libstdc++```

#### Clean script
- Run the clean script from ```scripts/cleanAll``` to remove pre-compiled code and the final built library


============

#### Documentation on Boost 1.60.0


See: http://www.boost.org/users/history/version_1_60_0.html


### Version 1.60.0 (Date): December 17th, 2015 15:52 GMT

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
