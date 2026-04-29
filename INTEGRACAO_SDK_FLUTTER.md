# Integracao do SDK Flutter em apps nativos

Este documento descreve como apps nativos devem consumir o SDK.

O app host nao precisa conhecer a implementacao Flutter. Ele deve consumir um wrapper nativo:

- iOS: `NossoFlutterSDK`
- Android: `NossoFlutterSDK`

O wrapper encapsula:

- Inicializacao do Flutter.
- Criacao da tela Flutter.
- Envio do token de autenticacao.
- Comunicacao via channel.

## 1. iOS

### 1.1. App iOS com CocoaPods

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

Abrir o app pelo `.xcworkspace`.

### 1.2. App iOS sem CocoaPods

Adicionar os artefatos fornecidos pelo SDK no projeto:

```text
NossoFlutterSDK
App.xcframework
Flutter.xcframework
```

No Xcode:

```text
Target > General > Frameworks, Libraries, and Embedded Content
```

Configurar os frameworks como:

```text
Embed & Sign
```

Se os frameworks estiverem em uma pasta versionada, adicionar o caminho em:

```text
Target > Build Settings > Framework Search Paths
```

Exemplo:

```text
$(PROJECT_DIR)/Vendor/NossoFlutterSDK/$(CONFIGURATION)
```

### 1.3. Uso no app iOS

UIKit:

```swift
import NossoFlutterSDK

NossoFlutterSDK.shared.start(authToken: token)

let viewController = NossoFlutterSDK.shared.makeViewController()
navigationController?.pushViewController(viewController, animated: true)
```

SwiftUI:

```swift
import NossoFlutterSDK

NavigationStack {
    Button("Abrir SDK") {
        NossoFlutterSDK.shared.start(authToken: token)
        isShowingSdk = true
    }
    .navigationDestination(isPresented: $isShowingSdk) {
        NossoFlutterSDKView()
            .navigationTitle("SDK")
            .navigationBarTitleDisplayMode(.inline)
    }
}
```

## 2. Android

### 2.1. App Android consumindo via Maven

Adicionar o repositorio onde o SDK foi publicado:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.suaempresa.com/releases")
        }
    }
}
```

Adicionar a dependencia:

```kotlin
dependencies {
    implementation("com.empresa:nosso-flutter-sdk:1.0.0")
}
```

### 2.2. Uso no app Android

Inicializar no `Application` ou antes do primeiro uso:

```kotlin
NossoFlutterSDK.initialize(applicationContext)
```

Abrir o SDK a partir de uma `Activity`:

```kotlin
val sdk = NossoFlutterSDK.get()

sdk.start(authToken = token)
startActivity(sdk.createActivityIntent(this))
```

## 3. Contrato de autenticacao

O app host deve enviar o token antes de abrir o SDK.

iOS:

```swift
NossoFlutterSDK.shared.start(authToken: token)
```

Android:

```kotlin
NossoFlutterSDK.get().start(authToken = token)
```

O token usado deve ser o token de sessao/autenticacao do usuario logado no app host.

## 4. Publicacao dos artefatos

Nosso time publica os artefatos versionados do SDK.

### iOS

Artefatos:

```text
NossoFlutterSDK.podspec
Package.swift
Sources/NossoFlutterSDK
Frameworks/App.xcframework
Frameworks/Flutter.xcframework
```

Gerar pacote local:

```sh
sh scripts/package_ios_sdk_release.sh 1.0.0
```

Saida:

```text
build/ios-sdk-release/NossoFlutterSDK-1.0.0.zip
```

### Android

Artefatos:

```text
flutter-aar-repo/
wrapper/
```

Gerar pacote local:

```sh
sh scripts/package_android_sdk_release.sh 1.0.0
```

Saida:

```text
build/android-sdk-release/NossoFlutterSDK-Android-1.0.0.zip
```

## 5. Checklist para apps consumidores

- O app chama `start(authToken:)` ou `start(authToken = ...)` antes de abrir o SDK.
- O app navega para a tela criada pelo wrapper nativo.
- O app nao acessa diretamente `FlutterEngine`, `FlutterViewController`, `FlutterActivity` ou `MethodChannel`.
- iOS com CocoaPods usa `pod 'NossoFlutterSDK'`.
- iOS sem CocoaPods adiciona os frameworks fornecidos.
- Android usa dependencia Maven do SDK.
