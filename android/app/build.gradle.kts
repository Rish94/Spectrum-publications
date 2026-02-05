import java.util.Properties // FIX: This was missing!

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.spectrum_app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        // FIX: Using "getByName" or "create" is safer in Kotlin Script
        create("release") {
            storeFile = file("release-key.jks") 
            storePassword = "Rish@844541"
            keyAlias = "releaseKey"
            keyPassword = "Rish@844541"
        }
    }

    defaultConfig {
        applicationId = "com.spectrum_app"
        minSdk = 21 // Manually set to 21 for 16KB support
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        externalNativeBuild {
            cmake {
                arguments("-DANDROID_ALIGNED_16KB=ON")
            }
        }
    }

    packaging {
        jniLibs {
            useLegacyPackaging = false
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
