allprojects {
    repositories {
        google()
        mavenCentral()
    }

    tasks.matching { it.name == "generateLockfiles" }.all {
        enabled = false
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
