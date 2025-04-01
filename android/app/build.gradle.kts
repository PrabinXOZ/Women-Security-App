plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    compileSdk = 30  // or your desired SDK version
    ndkVersion = "27.0.12077973"  // Ensure this matches your NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.women_security_app"
        minSdk = 21  // or your minSdk version
        targetSdk = 30  // or your targetSdk version
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    lintOptions {
        disable("InvalidPackage")
    }

    // Enable core desugaring (required for Java 8 features)
    coreLibraryDesugaringEnabled = true  // This is crucial for Java 8 features
}

dependencies {
    // Add this line to include desugaring support
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.1.5")
    
    // Other dependencies...
}


flutter {
    source = "../.."
}
