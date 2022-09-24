import command.universe
import command.universe.Universe
import picocli.CommandLine
import picocli.CommandLine.{Command, Option, Parameters, HelpCommand}

@Command(name = "axis-cli", subcommands = Array(classOf[Universe]))
class AxisCLI {

}

object AxisCLI {
    def main(args: Array[String]): Unit = {
        val exitCode: Int = new CommandLine(new AxisCLI()).execute(args: _*)
        System.exit(exitCode)
    }
}
