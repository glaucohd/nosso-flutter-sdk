# Integracao do NossoFlutterSDK

Este documento mostra como um app nativo consome o `NossoFlutterSDK` como dependencia versionada.

O SDK e publicado pelo nosso time nos gerenciadores nativos:

```text
iOS sem CocoaPods -> Swift Package Manager
iOS com CocoaPods -> CocoaPods
Android -> Maven
```

## 1. iOS sem CocoaPods

Use Swift Package Manager.

No Xcode:

```text
File > Add Package Dependencies...
https://github.com/glaucohd/nosso-flutter-sdk
Version: usar a versao mais recente publicada, hoje 1.0.1
Product: NossoFlutterSDK
```

Depois, no `ContentView.swift`:

```swift
import SwiftUI
import NossoFlutterSDK

struct ContentView: View {
    @State private var isShowingSdk = false
    // Token de autenticacao do usuario logado, por exemplo um JWT.
    private let token = "token-ios-teste"

    var body: some View {
        NavigationStack {
            Button("Abrir SDK Flutter") {
                NossoFlutterSDK.shared.start(authToken: token)
                isShowingSdk = true
            }
            .navigationDestination(isPresented: $isShowingSdk) {
                NossoFlutterSDKView()
                    .ignoresSafeArea()
                    .navigationTitle("SDK")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationTitle("App iOS")
        }
    }
}
```

Esse fluxo faz um push nativo para a tela do SDK.

Arquivos que o Xcode pode alterar automaticamente:

```text
*.xcodeproj/project.pbxproj
*.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
```

Se o projeto usa `.xcworkspace`, o `Package.resolved` pode ficar dentro do `.xcworkspace`.

## 2. iOS com CocoaPods

No `Podfile`:

```ruby
target 'AppHost' do
  use_frameworks!

  pod 'NossoFlutterSDK', '~> 1.0'
end
```

Depois:

```sh
pod install
```

Abra o app pelo `.xcworkspace`.

## 3. Abrir o SDK no iOS

O app precisa enviar o token antes de abrir a tela.

### UIKit

```swift
import NossoFlutterSDK

NossoFlutterSDK.shared.start(authToken: token)

let viewController = NossoFlutterSDK.shared.makeViewController()
navigationController?.pushViewController(viewController, animated: true)
```

### SwiftUI

```swift
import SwiftUI
import NossoFlutterSDK

struct ContentView: View {
    @State private var isShowingSdk = false
    let token: String

    var body: some View {
        NavigationStack {
            Button("Abrir SDK") {
                NossoFlutterSDK.shared.start(authToken: token)
                isShowingSdk = true
            }
            .navigationDestination(isPresented: $isShowingSdk) {
                NossoFlutterSDKView()
                    .ignoresSafeArea()
                    .navigationTitle("SDK")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
```

## 4. Android

No `settings.gradle.kts`, adicione o repositorio Maven do SDK:

```kotlin
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.suaempresa.com/releases")
        }
    }
}
```

No `build.gradle.kts` do app:

```kotlin
dependencies {
    implementation("com.glaucohd:nosso-flutter-sdk:1.0.1")
}
```

Abrir o SDK:

```kotlin
import com.glaucohd.nossofluttersdk.NossoFlutterSDK

val sdk = NossoFlutterSDK.get()

sdk.start(authToken = token)
startActivity(sdk.createActivityIntent(this))
```

## 5. Checklist rapido

- iOS sem CocoaPods: adicionar o pacote via Swift Package Manager.
- iOS com CocoaPods: adicionar o pod no `Podfile` e rodar `pod install`.
- Android: adicionar o repositorio Maven e a dependencia.
- Antes de abrir o SDK, sempre enviar o token.
