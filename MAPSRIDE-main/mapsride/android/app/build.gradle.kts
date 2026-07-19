plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mon_app"
    compileSdk = 34

    // Ajoute ceci pour satisfaire le nouveau DSL
    androidComponents {
        onVariants(selector().all()) {
            // Configuration spécifique si nécessaire
        }
    }

    defaultConfig {
        minSdk = 21
        targetSdk = 34
    }
}

flutter {
    source = "../.."
}
