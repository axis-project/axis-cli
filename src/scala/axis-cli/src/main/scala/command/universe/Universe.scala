package command.universe

import picocli.CommandLine
import picocli.CommandLine.{Command, HelpCommand, Option, Parameters}

import java.util.concurrent.Callable


@Command(name="universe", subcommands = Array(classOf[HelpCommand]))
class Universe {
    @Command
    def create(@Option(names=Array("--description","-d")) description: String): Unit = {

    }
}