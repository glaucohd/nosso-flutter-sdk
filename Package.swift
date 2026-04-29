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
            url: "https://github.com/glaucohd/nosso-flutter-sdk/releases/download/1.0.1/NossoFlutterSDK-Flutter-Debug-1.0.1.zip",
            checksum: "cb223ffe785f17bb0e2227349b804b2a38290c4d9e35e2a97e3c9e07d2a0394d"
        ),
        .binaryTarget(
            name: "App",
            url: "https://github.com/glaucohd/nosso-flutter-sdk/releases/download/1.0.1/NossoFlutterSDK-App-Debug-1.0.1.zip",
            checksum: "471a2d69dffcd8ecb75dc814d034cb01c350e5cf5b6bf3ccce36ac1dd65fcba0"
        ),
        .target(
            name: "NossoFlutterSDK",
            dependencies: [
                "Flutter",
                "App"
            ],
            path: "ios_sdk_distribution/Sources/NossoFlutterSDK"
        )
    ]
)
