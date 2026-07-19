plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("org.jetbrains.kotlin.android") // Ajout nécessaire pour le nouveau DSL
}

android {
    namespace = "com.example.mon_app"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Voici la nouvelle syntaxe moderne que Gradle réclame :
    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    defaultConfig {
        minSdk = 21
        targetSdk = 36
    }
}

flutter {
    source = "../.."
}
