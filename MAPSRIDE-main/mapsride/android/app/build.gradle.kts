plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mon_app"
    compileSdk = 36

    // AJOUTE CE BLOC ICI
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    // -------------------

    defaultConfig {
        minSdk = 21
        targetSdk = 36
    }
}

flutter {
    source = "../.."
}
