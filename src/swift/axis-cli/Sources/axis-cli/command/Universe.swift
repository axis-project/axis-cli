import ArgumentParser



struct Universe: ParsableCommand {
    static var configuration = CommandConfiguration(
            subcommands: [Create.self, List.self, Show.self, Delete.self, Update.self])
}


extension Universe {
    struct Create: ParsableCommand {
        @Argument var name: String
        @Option(name: .shortAndLong) var description: String?

        mutating func run() throws {
            try AxisUniverse.Create(name: name, description: description)
        }
    }

    struct List: ParsableCommand {
        mutating func run() throws {
            let universes = try AxisUniverse.List()
            AxisUniverse.printRecords(universes: universes)
        }
    }

    struct Show: ParsableCommand {
        @Argument var name: String

        mutating func run() throws {
            let universe = try AxisUniverse.Find(name: name)
            AxisUniverse.printRecords(universes: [universe])
        }
    }

    struct Delete: ParsableCommand {
        @Argument var name: String

        mutating func run() throws {
            try AxisUniverse.Delete(name: name)
        }
    }

    struct Update: ParsableCommand {
        @Argument var name: String
        @Option(name: .customLong("name")) var newName: String?
        @Option(name: .shortAndLong) var description: String?

        mutating func run() throws {
            try AxisUniverse.Update(name: name, newName: newName, description: description)
        }
    }
}