package data
import slick.jdbc.H2Profile.api._

import scala.concurrent.Await
import scala.concurrent.duration.Duration

object DataUtils {
    def db = Database.forConfig("h2embed")

    Await.result(DataUtils.db.run(DBIO.seq(
        AxisUniverse.universes.schema.createIfNotExists,
        AxisItem.items.schema.createIfNotExists,
    )), Duration.Inf)

    def printNonEmptyItems(items: Seq[Map[String,Any]], fields: Array[String]): Unit = {
        fields.foreach(t => print(s"${t}\t\t"))
        println()
        fields.foreach(_ => print("___________\t\t"))
        println()
        assert(items.nonEmpty, "Empty print result")
        items.foreach(map => {
            fields.foreach (k => print(s"${map(k)}\t\t"))
            println()
        })
    }
}
