import FluentKit
import NIO
import FluentSQLiteDriver
import Foundation

var axisDatabase: AxisDatabase = AxisDatabase()
var database: Database = axisDatabase.database
let migrations: [Migration] = [
    AxisUniverse.AxisUniverseMigration(),
    AxisItem.AxisItemMigration()
]

class AxisDatabase {
    var eventLoopGroup: EventLoopGroup!
    var threadPool: NIOThreadPool!
    
    var databases: Databases

    public var database: Database {
        self.databases.database(
            logger: .init(label: "axis-database"),
            on: self.databases.eventLoopGroup.next()
        )!
    }
    

    init() {
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.threadPool = NIOThreadPool(numberOfThreads: 2)
        self.threadPool.start()
        self.databases = Databases(threadPool: self.threadPool, on: self.eventLoopGroup)
        let dbFilePath = ProcessInfo.processInfo.environment["AXIS_HOME"] ?? "/Users/duowang/.axis"
        self.databases.use(.sqlite(.file("\(dbFilePath)/axis.db")), as: .sqlite)
        for migration in migrations {
            try? migration.prepare(on: self.database).wait()
        }
    }
}
