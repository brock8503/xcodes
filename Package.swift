// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "xcodes",
    platforms: [
       .macOS(.v13),
       .iOS(.v17)
    ],
    products: [
        .executable(name: "xcodes", targets: ["xcodes"]),
        .library(name: "XcodesCLIKit", targets: ["XcodesCLIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", revision: "9f39744e025c7d377987f30b03770805dcb0bcd1"), // 1.1.4
        .package(url: "https://github.com/mxcl/Path.swift.git", revision: "74ec90bbe50a3376e399286fed48b60db9b91bb1"), // 1.6.0
        .package(url: "https://github.com/mxcl/Version.git", revision: "087c91fedc110f9f833b14ef4c32745dabca8913"), // 1.0.3
        .package(url: "https://github.com/scinfu/SwiftSoup.git", revision: "aeb5b4249c273d1783a5299e05be1b26e061ea81"), // 2.0.0
        .package(url: "https://github.com/mxcl/LegibleError.git", revision: "bc596702d7ff618c3f90ba480eeb48b3e83a2fbe"), // 1.0.6
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", revision: "8d33ffd6f74b3bcfc99af759d4204c6395a3f918"), // 3.2.1
        .package(url: "https://github.com/xcodereleases/data", revision: "fcf527b187817f67c05223676341f3ab69d4214d"),
        .package(url: "https://github.com/onevcat/Rainbow.git", revision: "626c3d4b6b55354b4af3aa309f998fae9b31a3d9"), // 3.2.0
        .package(url: "https://github.com/brock8503/XcodesLoginKit.git", revision: "cef69dddbda365fa8d54c6d85592bcef615fcf4b"), // hardened
        .package(url: "https://github.com/brock8503/XcodesKit.git", revision: "df8320ad814056f1aa204d494e71df94e7422fb4") // hardened
    ],
    targets: [
        .executableTarget(
            name: "xcodes",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "XcodesCLIKit",
                .product(name: "XcodesKit", package: "XcodesKit")
            ]),
        .testTarget(
            name: "xcodesTests",
            dependencies: [
                "xcodes"
            ]),
        .target(
            name: "XcodesCLIKit",
            dependencies: [
                "KeychainAccess",
                "LegibleError",
                .product(name: "Path", package: "Path.swift"), 
                "SwiftSoup",
                "Version",
                .product(name: "XCModel", package: "data"),
                "XcodesLoginKit",
                .product(name: "XcodesKit", package: "XcodesKit"),
                "Rainbow"
            ],
            path: "Sources/XcodesKit"),
        .testTarget(
            name: "XcodesKitTests",
            dependencies: [
                "XcodesCLIKit",
                .product(name: "XcodesKit", package: "XcodesKit"),
                "Version"
            ],
            resources: [
                .copy("Fixtures"),
            ]),
    ]
)
