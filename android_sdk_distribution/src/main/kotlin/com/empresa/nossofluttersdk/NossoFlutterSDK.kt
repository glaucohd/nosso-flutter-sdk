package com.empresa.nossofluttersdk

import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class NossoFlutterSDK private constructor(
    context: Context,
) {
    private val appContext = context.applicationContext
    private var currentAuthToken: String? = null

    private val flutterEngine: FlutterEngine by lazy {
        FlutterEngine(appContext).also { engine ->
            engine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault(),
            )
            FlutterEngineCache.getInstance().put(ENGINE_ID, engine)
            configureAuthChannel(engine)
        }
    }

    fun prepare() {
        flutterEngine
    }

    fun start(authToken: String) {
        prepare()
        currentAuthToken = authToken

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUTH_CHANNEL)
            .invokeMethod("authTokenUpdated", mapOf("token" to authToken))
    }

    fun createActivityIntent(context: Context): Intent {
        prepare()
        return FlutterActivity
            .withCachedEngine(ENGINE_ID)
            .build(context)
    }

    private fun configureAuthChannel(engine: FlutterEngine) {
        MethodChannel(engine.dartExecutor.binaryMessenger, AUTH_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAuthToken" -> result.success(currentAuthToken)
                    else -> result.notImplemented()
                }
            }
    }

    companion object {
        private const val ENGINE_ID = "nosso_flutter_sdk_engine"
        private const val AUTH_CHANNEL = "com.empresa.flutter_sdk/auth"

        @Volatile
        private var instance: NossoFlutterSDK? = null

        fun initialize(context: Context): NossoFlutterSDK {
            return instance ?: synchronized(this) {
                instance ?: NossoFlutterSDK(context).also { instance = it }
            }
        }

        fun get(): NossoFlutterSDK {
            return requireNotNull(instance) {
                "NossoFlutterSDK.initialize(context) deve ser chamado antes de usar o SDK."
            }
        }
    }
}
