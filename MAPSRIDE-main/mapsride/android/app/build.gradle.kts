plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.mon_app"
    // On redescend à 34 : c'est le compromis parfait pour la compatibilité
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
        // targetSdk à 34 est la norme actuelle stable
        targetSdk = 34
    }
}

flutter {
    source = "../.."
}
