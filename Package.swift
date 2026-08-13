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
            url: "https://github.com/danoli3/ofxiOSBoost/releases/download/1.74.0/ofxiOSBoost-1.74.0-xcframework.zip",
            checksum: "4f28eb2f652e685c0e905ba2605ca3393b97e60d9ffc5efe719698172add57ec"
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
