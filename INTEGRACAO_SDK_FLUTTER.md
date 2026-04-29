# Integracao do NossoFlutterSDK

Este documento mostra como um app nativo consome o `NossoFlutterSDK` como dependencia versionada.

O SDK e publicado pelo nosso time nos gerenciadores nativos:

```text
iOS -> Swift Package Manager
Android -> Maven
```

## 1. iOS

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

    // Token de autenticacao do usuario logado no app host, por exemplo um JWT.
    // O SDK usa esse token para iniciar a sessao do usuario dentro do modulo Flutter.
    private let token = "token-ios-teste"

    var body: some View {
        NavigationStack {
            Button("Abrir SDK Flutter") {
                // Primeiro envie o token para o SDK.
                // Depois navegue para a tela Flutter.
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

### UIKit como alternativa

Se o app usa UIKit:

```swift
import NossoFlutterSDK

NossoFlutterSDK.shared.start(authToken: token)

let viewController = NossoFlutterSDK.shared.makeViewController()
navigationController?.pushViewController(viewController, animated: true)
```

## 2. Android

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

## 3. Checklist rapido

- iOS: adicionar o pacote via Swift Package Manager.
- Android: adicionar o repositorio Maven e a dependencia.
- Antes de abrir o SDK, sempre enviar o token.
