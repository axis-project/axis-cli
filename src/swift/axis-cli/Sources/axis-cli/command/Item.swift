import ArgumentParser
import Foundation


struct Item: ParsableCommand {
    static var configuration = CommandConfiguration(
            subcommands: [Create.self, List.self, Search.self, Show.self, Delete.self, Update.self, Move.self])
}


extension Item {
    struct Create: ParsableCommand {
        @Argument var title: String
        @Option(name: .shortAndLong) var description: String?
        @Option(name: .shortAndLong) var universe: String
        @Option(name: .long) var due: String?
        @Option(name: .shortAndLong) var priority: UInt?

        mutating func run() throws {
            let formatter = ISO8601DateFormatter()
            // formatter.timeZone = TimeZone.current
            let timeDue = due != nil ? formatter.date(from: due!)! : nil
            try AxisItem.Create(title: title, description: description, universeName: universe, timeDue: timeDue, priority: priority)
        }
    }

    struct List: ParsableCommand {
        mutating func run() throws {
            let items = try AxisItem.List()
            AxisItem.printRecords(items: items)
        }
    }

    struct Search: ParsableCommand {
        @Argument var keyword: String
        @Flag(name: [.long, .customShort("d")]) var searchDescription = false

        mutating func run() throws {
            let items = try AxisItem.Search(keyword: keyword, searchDescription: searchDescription)
            AxisItem.printRecords(items: items)
        }
    }

    struct Show: ParsableCommand {
        @Argument var id: Int?

        mutating func run() throws {
            let item = try AxisItem.Find(id: id!)
            AxisItem.printRecords(items: [item])
        }
    }

    struct Delete: ParsableCommand {
        @Argument var id: Int?

        mutating func run() throws {
            try AxisItem.Delete(id: id!)
        }
    }

    struct Update: ParsableCommand {
        @Argument var id: Int?
        @Option(name: .shortAndLong) var title: String?
        @Option(name: .shortAndLong) var description: String?
        @Option(name: .long) var due: String?
        @Option(name: .shortAndLong) var priority: UInt?

        mutating func run() throws {
            let formatter = ISO8601DateFormatter()
            // formatter.timeZone = TimeZone.current
            let timeDue = due != nil ? formatter.date(from: due!)! : nil
            try AxisItem.Update(id: id!, title: title, description: description, timeDue: timeDue, priority: priority)
        }
    }

    struct Move: ParsableCommand {
        @Argument var id: Int?
        @Option(name: .shortAndLong) var universe: String

        mutating func run() throws {
            try AxisItem.Update(id: id!, universeName: universe)
        }
    }
}