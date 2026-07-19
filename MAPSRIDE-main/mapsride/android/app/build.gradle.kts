plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.mon_app"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    defaultConfig {
        minSdk = 21
        targetSdk = 34
    }
}

// ON FORCE UNE VERSION DE CORE COMPATIBLE AVEC LE SDK 34
configurations.all {
    resolutionStrategy {
        force("androidx.core:core:1.13.1")
    }
}

flutter {
    source = "../.."
}
