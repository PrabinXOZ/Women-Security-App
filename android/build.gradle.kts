buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // AGP 7.0.4 or higher
        classpath("com.android.tools.build:gradle:7.0.4")  
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.5.20")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set the build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Ensure subprojects are included in build process
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Add this for the clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
