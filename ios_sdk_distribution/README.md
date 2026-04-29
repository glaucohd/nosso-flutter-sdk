# NossoFlutterSDK iOS

Este pacote e a camada nativa iOS do SDK Flutter.

O app iOS consumidor nao precisa conhecer `FlutterEngine`, `FlutterViewController` ou `MethodChannel`.

## Uso no app iOS

```swift
import NossoFlutterSDK

NossoFlutterSDK.shared.start(authToken: token)
let viewController = NossoFlutterSDK.shared.makeViewController()
navigationController?.pushViewController(viewController, animated: true)
```

Em SwiftUI:

```swift
import NossoFlutterSDK

NossoFlutterSDK.shared.start(authToken: token)

NossoFlutterSDKView()
    .navigationTitle("SDK")
```

## Artefatos esperados

```text
Frameworks/App.xcframework
Frameworks/Flutter.xcframework
Sources/NossoFlutterSDK/NossoFlutterSDK.swift
Package.swift
NossoFlutterSDK.podspec
```
