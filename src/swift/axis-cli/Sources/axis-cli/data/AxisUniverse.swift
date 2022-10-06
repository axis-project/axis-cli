import FluentKit
// import FluentSQL
import Foundation
// import FluentSQLiteDriver

final class AxisUniverse : Model {
    static let schema = "AxisUniverse"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String

    init() { }

    init(id: Int? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}


extension AxisUniverse {
    struct AxisUniverseMigration: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            // Make a change to the database.
            return database.schema("AxisUniverse")
                                .field("id", .int, .identifier(auto: true))
                                .field("name", .string, .required)
                                .unique(on: "name")
                                .field("description", .string)
                                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            // Undo the change made in `prepare`, if possible.
            database.schema("AxisUniverse").delete()
        }
    }
}


extension AxisUniverse {
    static func Create(name: String, description: String?) throws {
        let universe: AxisUniverse = AxisUniverse(name: name, description: description ?? "")
        try universe.create(on: database).wait()
    }

    static func List() throws -> [AxisUniverse] {
        let universes = try AxisUniverse.query(on: database).all().wait()
        return universes
    }

    static func Find(name: String) throws -> AxisUniverse {
        let universe = try AxisUniverse.query(on: database).filter(\.$name == name).first().wait()
        return universe!
    }

    static func Delete(name: String) throws {
        let _ = try Find(name: name)
        try AxisUniverse.query(on: database).filter(\.$name == name).delete().wait()
    }

    static func Update(name: String, newName: String?, description: String?) throws {
        var query = AxisUniverse.query(on: database).filter(\.$name == name)
        if let _name = newName {
            query = query.set(\.$name, to: _name)
        }
        if let _description = description {
            query = query.set(\.$description, to: _description)
        }
        try query.update().wait()
    }

    static func printRecords(universes: [AxisUniverse]) {
        print("Name\t\tDescription")
        print("----\t\t----")
        for u in universes {
            print("\(u.name)\t\t\(u.description)")
        }
    }
}