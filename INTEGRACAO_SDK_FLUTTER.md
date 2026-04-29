# Integração do NossoFlutterSDK

Este documento apresenta como integrar o `NossoFlutterSDK` em apps nativos.

## Disponibilidade

| Plataforma | Gerenciador |
|------------|-------------|
| **iOS** | Swift Package Manager |
| **Android** | Maven |

## 📱 iOS

### Adição via Swift Package Manager

1. No Xcode: `File > Add Package Dependencies...`
2. URL: `https://github.com/glaucohd/nosso-flutter-sdk`
3. Versão: `1.0.1` (mais recente)
4. Product: `NossoFlutterSDK`

### Implementação

**SwiftUI (`ContentView.swift`):**

```swift
import SwiftUI
import NossoFlutterSDK

struct ContentView: View {
    @State private var isShowingSdk = false

    // Token de autenticação do usuário (ex: JWT)
    // Utilizado para inicializar a sessão no SDK
    private let token = "token-ios-teste"

    var body: some View {
        NavigationStack {
            Button("Abrir SDK Flutter") {
                // Configura o token e navega para o SDK
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

> ⚡ Isso realizará uma navegação nativa para a tela do SDK.

### Alternativa UIKit

**UIKit:**

```swift
import NossoFlutterSDK

NossoFlutterSDK.shared.start(authToken: token)

let viewController = NossoFlutterSDK.shared.makeViewController()
navigationController?.pushViewController(viewController, animated: true)
```

## 🤖 Android

### Configuração do Repositório

No `settings.gradle.kts`:

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

### Adição da Dependência

No `build.gradle.kts` do app:

```kotlin
dependencies {
    implementation("com.glaucohd:nosso-flutter-sdk:1.0.1")
}
```

### Utilização

**Kotlin:**

```kotlin
import com.glaucohd.nossofluttersdk.NossoFlutterSDK

val sdk = NossoFlutterSDK.get()

sdk.start(authToken = token)
startActivity(sdk.createActivityIntent(this))
```

---

## ✅ Checklist de Integração

### iOS
- [ ] Adicionar package via Swift Package Manager
- [ ] Configurar token de autenticação
- [ ] Implementar navegação (SwiftUI ou UIKit)

### Android
- [ ] Configurar repositório Maven
- [ ] Adicionar dependência
- [ ] Configurar token de autenticação
- [ ] Implementar abertura do SDK

> ⚠️ **Importante**: Sempre configurar o token de autenticação antes de abrir o SDK.
