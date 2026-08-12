// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Boost",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "ofxiOSBoost", targets: ["ofxiOSBoost"]),
        .library(name: "boost", targets: ["boost"])
    ],
    targets: [
        .binaryTarget(
            name: "boost",
            url: "https://github.com/danoli3/ofxiOSBoost/releases/download/1.71.0/ofxiOSBoost-1.71.0-xcframework.zip",
            checksum: "85bb6db1338ba2b345c8ac6856e012269de421e43c3fe3d05873d6e2b08c8f90"
        ),
        .target(
            name: "ofxiOSBoost",
            dependencies: ["boost"],
            path: "example-swift-package/Package/Sources/ofxiOSBoostBridge",
            publicHeadersPath: "include"
        )
    ],
    cxxLanguageStandard: .cxx17
)
