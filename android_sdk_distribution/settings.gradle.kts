pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("com.android.library") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven {
            val storageUrl = System.getenv("FLUTTER_STORAGE_BASE_URL")
                ?: "https://storage.googleapis.com"
            url = uri("$storageUrl/download.flutter.io")
        }
        maven {
            val flutterAarRepo = providers
                .gradleProperty("flutterAarRepo")
                .getOrElse("../flutter-aar-repo")
            url = uri(flutterAarRepo)
        }
    }
}

rootProject.name = "NossoFlutterSDKAndroid"
