plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mon_app"
    compileSdk = 36 // Mis à jour à 36 pour satisfaire la dépendance

    androidComponents {
        onVariants(selector().all()) {
        }
    }

    defaultConfig {
        minSdk = 21
        targetSdk = 36 // Mis à jour à 36 pour la cohérence
    }
}

flutter {
    source = "../.."
}
