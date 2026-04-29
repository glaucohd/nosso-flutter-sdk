# Publicacao versionada do NossoFlutterSDK

Este documento e para o time que mantem o SDK Flutter e publica novas versoes para os apps nativos.

A doc do consumidor final fica em `INTEGRACAO_SDK_FLUTTER.md`.

## 1. Modelo de distribuicao

O SDK nasce versionado.

O consumidor nao baixa zip manualmente no fluxo final. Ele apenas declara a dependencia:

```text
iOS sem CocoaPods -> Swift Package Manager
iOS com CocoaPods -> CocoaPods
Android -> Maven
```

Por baixo dos panos, SPM, CocoaPods e Maven baixam os artefatos publicados pelo nosso time.

## 2. Definir a versao

Escolha a versao que sera publicada.

Exemplo:

```text
1.0.0
```

Use uma nova versao sempre que mudar tela Flutter, wrapper iOS, wrapper Android ou contrato de integracao.

Nao sobrescreva versoes antigas ja publicadas.

## 3. Validar antes de publicar

Na raiz do repo:

```sh
cd /Users/glauco/projetos/poc
```

Valide o Flutter:

```sh
cd flutter_module
flutter pub get
flutter analyze
flutter test
cd ..
```

## 4. Gerar artefatos iOS

Para iOS, gere os artefatos `Debug` e `Release`:

```sh
sh scripts/package_ios_sdk_release.sh 1.0.0 all
```

Saida:

```text
build/ios-sdk-release/NossoFlutterSDK-Debug-1.0.0.zip
build/ios-sdk-release/NossoFlutterSDK-Release-1.0.0.zip
```

Uso:

```text
Debug   -> simulador/build Debug no Xcode
Release -> homologacao, TestFlight, App Store e build Release
```

Esses zips sao detalhe de publicacao. O consumidor final deve receber coordenada SPM ou CocoaPods, nao instrucoes para baixar zip.

## 5. Publicar iOS em Swift Package Manager

O pacote SPM deve expor:

```text
NossoFlutterSDK
```

URL para o consumidor:

```text
https://github.com/glaucohd/nosso-flutter-sdk-ios
```

Versao:

```text
1.0.0
```

O `Package.swift` publicado deve apontar para os binarios versionados do SDK.

Fluxo esperado:

```text
1. Gerar artefato iOS.
2. Publicar os binarios da versao.
3. Atualizar o Package.swift.
4. Criar tag 1.0.0 no repo SPM.
5. Validar no Xcode via Add Package Dependency.
```

## 6. Publicar iOS em CocoaPods

O pod final para o consumidor deve ser:

```ruby
pod 'NossoFlutterSDK', '~> 1.0'
```

O `podspec` deve apontar para o artefato iOS publicado:

```ruby
s.version = '1.0.0'

s.source = {
  :http => 'https://github.com/glaucohd/nosso-flutter-sdk/releases/download/1.0.0/NossoFlutterSDK-Release-1.0.0.zip'
}
```

Fluxo esperado:

```text
1. Gerar artefato iOS Release.
2. Publicar zip na release 1.0.0.
3. Atualizar NossoFlutterSDK.podspec.
4. Publicar o podspec no reposititorio CocoaPods usado pela empresa.
5. Validar com pod install em um app consumidor.
```

Para POC, pode usar `:podspec => URL_DO_PODSPEC`. Para fluxo real, o ideal e o consumidor usar apenas `pod 'NossoFlutterSDK', '~> 1.0'`.

## 7. Gerar artefato Android

Android tambem precisa de artefatos, mas eles devem ser publicados em Maven.

Gerar pacote Android:

```sh
sh scripts/package_android_sdk_release.sh 1.0.0
```

Saida atual da POC:

```text
build/android-sdk-release/NossoFlutterSDK-Android-1.0.0.zip
```

Para o fluxo final, esse conteudo deve virar publicacoes Maven.

## 8. Publicar Android em Maven

Coordenada final para o consumidor:

```kotlin
implementation("com.glaucohd:nosso-flutter-sdk:1.0.0")
```

Repositorio Maven final:

```kotlin
maven {
    url = uri("https://maven.suaempresa.com/releases")
}
```

O que precisa ser publicado no Maven:

```text
com.glaucohd:nosso-flutter-sdk:1.0.0
com.example.flutter_module:flutter_debug:1.0
com.example.flutter_module:flutter_profile:1.0
com.example.flutter_module:flutter_release:1.0
```

O app consumidor declara apenas:

```kotlin
implementation("com.glaucohd:nosso-flutter-sdk:1.0.0")
```

As dependencias Flutter devem ser transitivas e resolvidas pelo Maven automaticamente.

## 9. Validar como consumidor

Validar os tres cenarios:

```text
iOS sem CocoaPods -> Xcode Add Package Dependency
iOS com CocoaPods -> pod 'NossoFlutterSDK', '~> 1.0'
Android -> implementation("com.glaucohd:nosso-flutter-sdk:1.0.0")
```

O consumidor nao deve precisar:

```text
baixar zip manualmente
rodar flutter
conhecer flutter_module
adicionar Flutter.xcframework
adicionar App.xcframework
adicionar AAR Flutter manualmente
```

## 10. Checklist rapido

- Versao nova definida.
- Flutter validado.
- Artefatos iOS gerados.
- Artefatos Android gerados.
- SPM publicado/tagueado.
- CocoaPods publicado.
- Maven publicado.
- iOS sem CocoaPods validado.
- iOS com CocoaPods validado.
- Android validado.
