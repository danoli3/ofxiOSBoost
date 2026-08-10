# Installed Boost dependency

This folder is updated by script or by release download! 

## If empty then follow the next steps

This directory is intentionally kept out of the repository's source tree.
Boost headers and compiled libraries are versioned release artifacts, not a
second copy of the source distribution. The checked-in `include/` tree was a
stale Boost 1.60 snapshot and has been removed.

To install the pinned release for this checkout, run from the repository root:

```sh
./scripts/install-boost
```

To install the newest published semantic release:

```sh
./scripts/install-boost latest
```

The installer downloads and verifies the release archive, then installs:

- `ios/boost.xcframework`, including the matching `Headers` for every slice;
- CMake package metadata under `cmake/`;
- pkg-config metadata under `pkgconfig/`.

For a local build instead of a published release, run
`BOOST_VERSION=<version> ./scripts/build-boost-ios`. Build output is written to
the ignored `dist/` directory and installed here as `ios/boost.xcframework`,
`cmake/`, and `pkgconfig/`. The same version-specific headers are included in
the generated archive and XCFramework.

Boost 1.65.0 includes compiled Boost.Context. Its low-level stack switching and
the header-only Boost.Coroutine2 API passed runtime tests on an arm64 Simulator
and a physical arm64 iOS device.

Do not add generated headers or binaries back to this directory. The main
versioned release tarball is assembled as a complete addon and includes the
matching XCFramework and headers automatically.
