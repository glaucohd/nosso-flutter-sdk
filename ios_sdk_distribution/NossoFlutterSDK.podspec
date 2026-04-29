Pod::Spec.new do |s|
  s.name = 'NossoFlutterSDK'
  s.version = '1.0.0'
  s.summary = 'SDK iOS wrapper para o modulo Flutter.'
  s.description = 'Wrapper nativo iOS que encapsula FlutterEngine, FlutterViewController e MethodChannel do SDK Flutter.'
  s.homepage = 'https://github.com/sua-org/nosso-flutter-sdk-ios'
  s.license = { :type => 'Proprietary' }
  s.author = { 'Sua Empresa' => 'ios@suaempresa.com' }
  s.platform = :ios, '13.0'
  s.swift_version = '5.0'

  s.source = {
    :http => 'https://github.com/sua-org/nosso-flutter-sdk-ios/releases/download/1.0.0/NossoFlutterSDK-1.0.0.zip'
  }

  s.source_files = 'Sources/NossoFlutterSDK/**/*.swift'
  s.vendored_frameworks = [
    'Frameworks/App.xcframework',
    'Frameworks/Flutter.xcframework'
  ]
end
