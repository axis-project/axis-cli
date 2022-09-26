package data
import slick.jdbc.H2Profile.api._

import scala.concurrent.Await
import scala.concurrent.duration.Duration

object DataUtils {
    def db = Database.forConfig("h2embed")

    Await.result(DataUtils.db.run(DBIO.seq(
        AxisUniverse.universes.schema.createIfNotExists,
    )), Duration.Inf)

    def printNonEmptyItems(items: Seq[Map[String,Any]]): Unit = {
        items.head.foreach(t => print(s"${t._1}\t\t"))
        println()
        items.head.foreach(_ => print("___________\t\t"))
        println()
        items.foreach(map => {
            map.foreach (t => print(s"${t._2}\t\t"))
            println()
        })
    }
}
