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
            url: "https://github.com/danoli3/ofxiOSBoost/releases/download/1.89.0/ofxiOSBoost-1.89.0-xcframework.zip",
            checksum: "db41550a80502fe5c1cd432dfddb16a066f6fde92020869139822d55ef792b38"
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
