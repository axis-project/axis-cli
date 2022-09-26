val scalaVer = "2.13.9"

lazy val root = project
    .in(file("."))
    .enablePlugins(NativeImagePlugin)
    .settings(
        name := "axis-cli",
        version := "0.1.0-SNAPSHOT",

        scalaVersion := scalaVer,
        libraryDependencies += "org.scalameta" %% "munit" % "0.7.29" % Test,
        libraryDependencies ++= Seq(
            "info.picocli" % "picocli" % "4.6.3",
            "info.picocli" % "picocli-codegen" % "4.6.3",
        ),
        libraryDependencies ++= Seq(
            "com.typesafe.slick" %% "slick" % "3.4.1",
            "com.h2database" % "h2" % "2.1.214",
            "org.slf4j" % "slf4j-nop" % "1.7.26",
            "com.typesafe.slick" %% "slick-hikaricp" % "3.4.1"
        ),
        Compile / mainClass := Some("Main"),
        nativeImageVersion := "22.2.0",
        nativeImageReady := (() => println("Native Image Ready!"))
    )
