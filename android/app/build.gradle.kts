plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.moodmap_final_gradlefix"
    compileSdk = flutter.compileSdkVersion

    // зчитуємо значення з local.properties
    val localProperties = java.util.Properties().apply {
        val localFile = rootProject.file("local.properties")
        if (localFile.exists()) {
            localFile.inputStream().use { load(it) }
        }
    }

    val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1
    val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

    defaultConfig {
        applicationId = "com.example.moodmap_final_gradlefix"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode
        versionName = flutterVersionName

        resValue("string", "MAPS_API_KEY", System.getenv("MAPS_API_KEY") ?: "YOUR_LOCAL_DEBUG_KEY")
        manifestPlaceholders["MAPS_API_KEY"] = System.getenv("MAPS_API_KEY") ?: "YOUR_LOCAL_DEBUG_KEY"
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
