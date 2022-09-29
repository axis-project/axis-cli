package command

import picocli.CommandLine.{Command, HelpCommand, Option, Parameters}
import data.{AxisUniverse, DataUtils}

@Command(name="universe", subcommands = Array(classOf[HelpCommand]))
class Universe {
    @Command
    def create(@Parameters name: String, @Option(names=Array("--description","-d"), defaultValue = "") description: String): Unit = {
        AxisUniverse.create(name, description)
    }

    @Command
    def list(): Unit = {
        var universes = AxisUniverse.list()
        if (universes.nonEmpty) {
            DataUtils.printNonEmptyItems(universes.collect(r => r.toMap()), AxisUniverse.printFields)
        }
    }

    @Command
    def show(@Parameters name: String): Unit = {
        var universes = AxisUniverse.find(name)
        DataUtils.printNonEmptyItems(universes.collect(r => r.toMap()), AxisUniverse.printFields)
    }

    @Command
    def delete(@Parameters name: String,  @Option(names=Array("--force","-f"), defaultValue = "false") force : Boolean): Unit = {
        AxisUniverse.delete(name)
    }

    @Command
    def update(@Parameters name: String, @Option(names = Array("--name")) newName: String, @Option(names = Array("--description", "-d")) newDescription: String): Unit = {
        AxisUniverse.update(name, newName, newDescription)
    }
}