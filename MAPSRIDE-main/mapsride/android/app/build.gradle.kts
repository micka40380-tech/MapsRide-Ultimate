plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.mon_app"
    compileSdk = 36

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
        targetSdk = 36
    }
}

// AJOUTE CE BLOC POUR FORCER LA COMPATIBILITÉ
configurations.all {
    resolutionStrategy {
        eachDependency {
            if (requested.group == "androidx.core" || requested.name.contains("geocoding")) {
                useTarget("${requested.group}:${requested.name}:1.13.1") // Force une version compatible
            }
        }
    }
}

flutter {
    source = "../.."
}
