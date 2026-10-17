import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.library")
    kotlin("android")
}

android {
    compileSdk = 34
    namespace = "com.andrerinas.openheadunit.contract"

    defaultConfig {
        minSdk = 16
    }

//    buildTypes {
//        create("release") {
//            postprocessing {
//                removeUnusedCode = false
//                removeUnusedResources = false
//                obfuscate = false
//                optimizeCode = false
//                proguardFile("proguard-rules.pro")
//            }
//        }
//    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_1_8)
        }
    }
    lint {
        targetSdk = 34
    }
    testOptions {
        targetSdk = 34
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.0")
}
