allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = java.io.File("../build")
subprojects {
    project.buildDir = java.io.File("${rootProject.buildDir}/${project.name}")
}
subprojects {
    afterEvaluate { project ->
        if (project.hasProperty("android")) {
            project.extensions.configure<com.android.build.gradle.BaseExtension> {
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
