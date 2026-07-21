plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

tasks.matching { it.name == "generateLockfiles" }.all {
    enabled = false
}

android {
    namespace = "com.micka40380.mapsride"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.micka40380.mapsride"
        minSdk = 21
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
    }
}

flutter {
    source = "../.."
}
