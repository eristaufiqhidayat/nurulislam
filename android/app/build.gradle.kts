import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    namespace = "com.eristaufiq.STIE_ReactNative_js"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.eristaufiq.STIE_ReactNative_js"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ==========================================================
    // Load key.properties (WAJIB PAKAI SYNTAX KOTLIN KTS)
    // ==========================================================
    val keystoreProperties = Properties()
    val keystorePropertiesFile = rootProject.file("../key.properties")
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storePassword = keystoreProperties["storePassword"] as String?
            storeFile = file(keystoreProperties["storeFile"] as String?)
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false

        }
    }
}

flutter {
    source = "../.."
}
