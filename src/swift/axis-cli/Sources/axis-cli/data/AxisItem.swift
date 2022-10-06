import FluentKit
import Foundation

final class AxisItem : Model {
    static let schema = "AxisItem"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "title")
    var title: String

    @Field(key: "description")
    var description: String

    @Field(key: "universe_id")
    var universeID: Int?

    @Field(key: "time_due")
    var timeDue: Date

    @Field(key: "priority")
    var priority: UInt

    init() { }

    init(id: Int? = nil, title: String, description: String, universeID: Int? = nil, timeDue: Date, priority: UInt) {
        self.id = id
        self.title = title
        self.description = description
        self.universeID = universeID
        self.timeDue = timeDue
        self.priority = priority
    }
}


extension AxisItem {
    struct AxisItemMigration: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            // Make a change to the database.
            return database.schema("AxisItem")
                                .field("id", .int, .identifier(auto: true))
                                .field("title", .string, .required)
                                .field("description", .string)
                                .field("time_due", .datetime, .required)
                                .field("priority", .uint8, .required)
                                .field("universe_id", .int, .required)
                                .foreignKey("universe_id", references: "AxisUniverse", "id")
                                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            // Undo the change made in `prepare`, if possible.
            database.schema("AxisItem").delete()
        }
    }
}


extension AxisItem {
    static func Create(title: String, description: String?, universeName: String, timeDue: Date?, priority: UInt?) throws {
        let universe: AxisUniverse = try! AxisUniverse.Find(name: universeName)
        let item = AxisItem(title: title, description: description ?? "", universeID: universe.id, timeDue: timeDue ?? Date.now, priority: priority ?? 1)
        try item.create(on: database).wait()
    }

    static func List() throws -> [AxisItem] {
        let items = try AxisItem.query(on: database).all().wait()
        return items
    }

    static func Find(id: Int) throws -> AxisItem {
        let item = try AxisItem.query(on: database).filter(\.$id == id).first().wait()
        return item!
    }

    static func Search(keyword: String, searchDescription: Bool) throws -> [AxisItem] {
        var items: [AxisItem]
        if searchDescription {
            items = try AxisItem.query(on: database).group(.or) { group in 
            group.filter(\.$title ~~ keyword).filter(\.$description ~~ keyword)}
            .all().wait()
        } else {
            items = try AxisItem.query(on: database).filter(\.$title ~~ keyword).all().wait()
        }
        return items
    }

    static func Delete(id: Int) throws {
        let _ = try Find(id: id)
        try AxisItem.query(on: database).filter(\.$id == id).delete().wait()
    }

    static func Update(id: Int, title: String? = nil, description: String? = nil, universeName: String? = nil, timeDue: Date? = nil, priority: UInt? = nil) throws {
        let _ = try Find(id: id)
        var query = AxisItem.query(on: database).filter(\.$id == id)
        if let _title = title {
            query = query.set(\.$title, to: _title)
        }
        if let _description = description {
            query = query.set(\.$description, to: _description)
        }
        if let _universeName = universeName {
            let universe: AxisUniverse = try AxisUniverse.Find(name: _universeName)
            query = query.set(\.$universeID, to: universe.id)
        }
        if let _timeDue = timeDue {
            query = query.set(\.$timeDue, to: _timeDue)
        }
        if let _priority = priority {
            query = query.set(\.$priority, to: _priority)
        }
        try query.update().wait()
    }

    static func printRecords(items: [AxisItem]) {
        print("Id\t\tTitle\t\tDescription\t\tUniverse\t\tTimeDue\t\tPriority")
        print("----\t\t----\t\t----\t\t----\t\t----\t\t----")
        var formatStyle = Date.ISO8601FormatStyle()
        formatStyle.timeZone = TimeZone.current
        for u in items {
            print("\(u.id!)\t\t\(u.title)\t\t\(u.description)\t\t\(u.universeID!)\t\t\(u.timeDue.formatted(formatStyle))\t\t\(u.priority)")
        }
    }
}