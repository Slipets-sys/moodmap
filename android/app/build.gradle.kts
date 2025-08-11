import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.moodmap_final_gradlefix"
    compileSdk = flutter.compileSdkVersion

    // Завантажуємо значення з local.properties (Flutter автоматично їх створює)
    val localProperties = Properties().apply {
        val localFile = rootProject.file("local.properties")
        if (localFile.exists()) {
            FileInputStream(localFile).use { load(it) }
        }
    }

    // Читаємо версію та код з local.properties
    val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1
    val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

    defaultConfig {
        applicationId = "com.example.moodmap_final_gradlefix"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode
        versionName = flutterVersionName

        // Підставляємо API ключ з GitHub Secrets або тестовий локальний
        val mapsApiKey = System.getenv("MAPS_API_KEY") ?: "YOUR_LOCAL_DEBUG_KEY"
        resValue("string", "MAPS_API_KEY", mapsApiKey)
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            val mapsApiKey = System.getenv("MAPS_API_KEY") ?: "YOUR_LOCAL_RELEASE_KEY"
            manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
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
