plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Solution radicale : force n'importe quel module Android (app ou bibliothèque) à basculer en SDK 36
    afterEvaluate {
        val extension = project.extensions.findByName("android")
        if (extension != null) {
            try {
                val method = extension.javaClass.getMethod("setCompileSdkVersion", Int::class.java)
                method.invoke(extension, 36)
            } catch (e: Exception) {
                try {
                    val method = extension.javaClass.getMethod("compileSdk", Int::class.java)
                    method.invoke(extension, 36)
                } catch (ignored: Exception) {}
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
