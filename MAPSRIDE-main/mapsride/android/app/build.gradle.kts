plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.mon_app"
    // On repasse en 36 car tous tes plugins récents le demandent
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

// CETTE LIGNE PERMET DE DIRE À ANDROID D'IGNORER LES CONFLITS DE COMPILATION DES PLUGINS
tasks.withType<JavaCompile>().configureEach {
    options.compilerArgs.add("-Xlint:-deprecation")
}

flutter {
    source = "../.."
}
