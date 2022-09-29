import command.{Item, Universe}
import picocli.CommandLine
import picocli.CommandLine.Command

@Command(name = "axis-cli", subcommands = Array(classOf[Universe], classOf[Item]))
class Main


object Main {
    def main(args: Array[String]): Unit = {
        var exitCode: Int = 0
        try {
            exitCode = new CommandLine(new Main()).execute(args: _*)
        } catch {
            case _: Exception => exitCode = -1
        } finally {
            System.exit(exitCode)
        }
    }
}

