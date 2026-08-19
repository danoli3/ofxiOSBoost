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
            url: "https://github.com/danoli3/ofxiOSBoost/releases/download/1.81.0/ofxiOSBoost-1.81.0-xcframework.zip",
            checksum: "f56702893a9ad7f0e2f7544dfc61a5ca7ff325fc117a2d7d26f4aae273fb7f21"
        ),
        .target(
            name: "ofxiOSBoost",
            dependencies: ["boost"],
            path: "example-swift-package/Package/Sources/ofxiOSBoostBridge",
            publicHeadersPath: "include"
        )
    ],
    cxxLanguageStandard: .cxx20
)
