plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mon_app"
    compileSdk = 34
}

flutter {
    source = "../.."
}
