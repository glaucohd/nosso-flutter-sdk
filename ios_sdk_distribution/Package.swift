// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NossoFlutterSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NossoFlutterSDK",
            targets: ["NossoFlutterSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Flutter",
            path: "Frameworks/Flutter.xcframework"
        ),
        .binaryTarget(
            name: "App",
            path: "Frameworks/App.xcframework"
        ),
        .target(
            name: "NossoFlutterSDK",
            dependencies: [
                "Flutter",
                "App"
            ],
            path: "Sources/NossoFlutterSDK"
        )
    ]
)
