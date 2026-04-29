import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SDK Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0057D9)),
        useMaterial3: true,
      ),
      home: const SdkHomePage(),
    );
  }
}

class SdkHomePage extends StatefulWidget {
  const SdkHomePage({super.key});

  @override
  State<SdkHomePage> createState() => _SdkHomePageState();
}

class _SdkHomePageState extends State<SdkHomePage> {
  static const _authChannel = MethodChannel('com.empresa.flutter_sdk/auth');

  String? _authToken;

  @override
  void initState() {
    super.initState();

    _authChannel.setMethodCallHandler(_handleNativeMethodCall);
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    final authToken = await _authChannel.invokeMethod<String>('getAuthToken');

    if (!mounted) {
      return;
    }

    setState(() {
      _authToken = authToken;
    });
  }

  Future<void> _handleNativeMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'authTokenUpdated':
        final arguments = call.arguments as Map<Object?, Object?>?;
        final authToken = arguments?['token'] as String?;

        if (!mounted) {
          return;
        }

        setState(() {
          _authToken = authToken;
        });
      default:
        throw MissingPluginException('Method not implemented: ${call.method}');
    }
  }

  String _maskedToken() {
    final authToken = _authToken;

    if (authToken == null || authToken.isEmpty) {
      return 'Token ainda nao recebido';
    }

    if (authToken.length <= 8) {
      return authToken;
    }

    return '${authToken.substring(0, 4)}...${authToken.substring(authToken.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SDK Flutter')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user_outlined, size: 72),
              const SizedBox(height: 24),
              const Text(
                'Modulo Flutter carregado',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esta tela recebeu a sessao enviada pelo app iOS nativo.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Auth token',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _maskedToken(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
