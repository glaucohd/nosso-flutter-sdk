plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.empresa.nossofluttersdk"
    compileSdk = 36

    defaultConfig {
        minSdk = 24
    }

    buildTypes {
        create("profile") {
            initWith(getByName("debug"))
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8)
    }
}

dependencies {
    releaseImplementation("com.example.flutter_module:flutter_release:1.0")
    debugImplementation("com.example.flutter_module:flutter_debug:1.0")
    add("profileImplementation", "com.example.flutter_module:flutter_profile:1.0")
}
