val scala3Version = "3.2.0"

lazy val root = project
    .in(file("."))
    .settings(
        name := "axis-cli",
        version := "0.1.0-SNAPSHOT",

        scalaVersion := scala3Version,
        libraryDependencies += "org.scalameta" %% "munit" % "0.7.29" % Test,
        libraryDependencies += "info.picocli" % "picocli" % "4.6.3",
        libraryDependencies += "info.picocli" % "picocli-codegen" % "4.6.3",


    )
