plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.moodmap_final_gradlefix"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.example.moodmap_final_gradlefix"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        resValue "string", "MAPS_API_KEY", System.getenv("MAPS_API_KEY") ?: ""


        // ✅ Підставляємо API ключ (спершу шукаємо в системних змінних, інакше тестовий)
        manifestPlaceholders["MAPS_API_KEY"] =
            System.getenv("MAPS_API_KEY") ?: "YOUR_LOCAL_DEBUG_KEY"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            manifestPlaceholders["MAPS_API_KEY"] =
                System.getenv("MAPS_API_KEY") ?: "YOUR_LOCAL_RELEASE_KEY"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.gms:play-services-maps:18.2.0")
    implementation("com.google.android.gms:play-services-location:21.0.1")
}
