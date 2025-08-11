plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

android {
    namespace = "com.example.moodmap_final_gradlefix"
    compileSdk = flutter.compileSdkVersion

    // Вирівнюємо версію JVM
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlin {
        jvmToolchain(17)
    }

    // Завантажуємо local.properties (для локального запуску)
    val localProperties = Properties()
    val localFile = rootProject.file("local.properties")
    if (localFile.exists()) {
        FileInputStream(localFile).use { localProperties.load(it) }
    }

    val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
    val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

    defaultConfig {
        applicationId = "com.example.moodmap_final_gradlefix"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName

        // Підставляємо API ключ: або з ENV (GitHub), або з local.properties, або тестовий
        val mapsApiKey = System.getenv("MAPS_API_KEY")
            ?: localProperties.getProperty("MAPS_API_KEY")
            ?: "YOUR_LOCAL_DEBUG_KEY"

        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            val mapsApiKey = System.getenv("MAPS_API_KEY")
                ?: localProperties.getProperty("MAPS_API_KEY")
                ?: "YOUR_LOCAL_RELEASE_KEY"
            manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
        }
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
            val mapsApiKey = System.getenv("MAPS_API_KEY")
                ?: localProperties.getProperty("MAPS_API_KEY")
                ?: "YOUR_LOCAL_DEBUG_KEY"
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
