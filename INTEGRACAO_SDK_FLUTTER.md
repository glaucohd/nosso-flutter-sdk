# Integracao do NossoFlutterSDK

Este documento mostra como um app nativo consome o `NossoFlutterSDK` como dependencia versionada.

O app consumidor nao precisa conhecer Flutter, baixar zip manualmente, rodar comandos Flutter ou adicionar `Flutter.xcframework`/`App.xcframework`.

O SDK e publicado pelo nosso time nos gerenciadores nativos:

```text
iOS sem CocoaPods -> Swift Package Manager
iOS com CocoaPods -> CocoaPods
Android -> Maven
```

Para gerar e publicar novas versoes do SDK, ver `PUBLICACAO_ARTEFATOS_SDK.md`.

## 1. iOS sem CocoaPods

Use Swift Package Manager.

### 1.1. Caminho rapido

No Xcode:

```text
File > Add Package Dependencies...
https://github.com/glaucohd/nosso-flutter-sdk
Version: 1.0.1
Product: NossoFlutterSDK
```

Depois, no `ContentView.swift`:

```swift
import SwiftUI
import NossoFlutterSDK

struct ContentView: View {
    @State private var isShowingSdk = false
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

### 1.2. O que muda no projeto

O consumidor mexe basicamente em:

```text
1. Xcode project -> adiciona a dependencia SPM.
2. Tela/fluxo onde abre o SDK -> importa NossoFlutterSDK e navega.
```

Nao precisa alterar `Podfile`, nao precisa baixar zip e nao precisa adicionar frameworks manualmente.

### 1.3. Adicionar dependencia SPM

No Xcode:

```text
File > Add Package Dependencies...
```

Informe a URL do pacote:

```text
https://github.com/glaucohd/nosso-flutter-sdk
```

Selecione a versao:

```text
1.0.1
```

Selecione o produto:

```text
NossoFlutterSDK
```

Pronto. O Xcode/SPM baixa a versao correta do SDK automaticamente.

Arquivos que o Xcode pode alterar automaticamente:

```text
*.xcodeproj/project.pbxproj
*.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
```

Se o projeto usa `.xcworkspace`, o `Package.resolved` pode ficar dentro do `.xcworkspace`.

### 1.4. Usar no app iOS

No arquivo Swift da tela ou coordinator que abre o SDK:

```swift
import NossoFlutterSDK
```

Antes de abrir a tela, envie o token:

```swift
NossoFlutterSDK.shared.start(authToken: token)
```

Depois navegue para a tela do SDK:

```swift
let viewController = NossoFlutterSDK.shared.makeViewController()
navigationController?.pushViewController(viewController, animated: true)
```

Se o app usa SwiftUI, use `NavigationStack` para fazer push nativo para a tela do SDK:

```swift
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
```

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
