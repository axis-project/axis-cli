package command

import data.{AxisItem, DataUtils}
import picocli.CommandLine.{Command, HelpCommand, Option, Parameters}

import java.time.OffsetDateTime

@Command(name="item", subcommands = Array(classOf[HelpCommand]))
class Item {
    @Command
    def create(@Parameters title: String,
               @Option(names=Array("--universe","-u"), required = true) universeName: String,
               @Option(names=Array("--description","-d"), defaultValue = "") description: String,
               @Option(names=Array("--priority","-p"), defaultValue = "0") priority: Int,
                @Option(names=Array("--due")) timeDue: OffsetDateTime): Unit = {
        AxisItem.create(title, universeName, description, timeDue: OffsetDateTime, priority: Int)
    }

    @Command
    def list(): Unit = {
        var items = AxisItem.list()
        if (items.nonEmpty) {
            DataUtils.printNonEmptyItems(items.collect(r => r.toMap()), AxisItem.printFields)
        }
    }

    @Command
    def search(@Parameters keyword: String, @Option(names=Array("--search-description","-d"), defaultValue = "false") searchDescription: Boolean): Unit = {
        var items = AxisItem.search(keyword, searchDescription)
        if (items.nonEmpty) {
            DataUtils.printNonEmptyItems(items.collect(r => r.toMap()), AxisItem.printFields)
        }
    }

    @Command
    def show(@Parameters id: Int): Unit = {
        var items = AxisItem.find(id)
        DataUtils.printNonEmptyItems(items.collect(r => r.toMap()), AxisItem.printFields)
    }

    @Command
    def delete(@Parameters id: Int): Unit = {
        AxisItem.delete(id)
    }

    @Command
    def update(@Parameters id: Int, @Option(names = Array("--title", "-t")) newTitle: String,
               @Option(names = Array("--description", "-d")) newDescription: String,
               @Option(names = Array("--priority", "-p"), defaultValue = "0") newPriority: Int,
               @Option(names = Array("--due")) newTimeDue: OffsetDateTime,
               @Option(names = Array("--status", "-s")) newStatus: String): Unit = {
        AxisItem.update(id, newTitle, newDescription, newTimeDue, newPriority, newStatus)
    }

    @Command
    def move(@Parameters id: Int, @Option(names=Array("--universe", "-u"), required = true) universeName: String): Unit = {
        AxisItem.move(id, universeName)
    }
}