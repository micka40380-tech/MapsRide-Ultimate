plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.micka40380.mapsride"
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
        applicationId = "com.micka40380.mapsride"
        minSdk = 21
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
    }
}

configurations.all {
    resolutionStrategy.eachDependency {
        if (requested.group == "androidx.exifinterface" && requested.name == "exifinterface") {
            useVersion("1.3.7")
        }
    }
}

flutter {
    source = "../.."
}
