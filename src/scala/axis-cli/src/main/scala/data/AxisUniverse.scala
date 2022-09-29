package data

import slick.jdbc.H2Profile.api._

import scala.collection.mutable.ArrayBuffer
import scala.concurrent.Await
import scala.concurrent.duration.{Duration, DurationInt}


case class AxisUniverse(var id: Option[Int], var name: String, var description: String = "") {
    def toMap(): Map[String, Any] = {
        Map("id" -> id, "name" -> name, "description" -> description)
    }
}

class UniverseEntity(tag: Tag) extends Table[AxisUniverse](tag, "Universe") {
    def id = column[Int]("id", O.PrimaryKey, O.AutoInc)
    def name = column[String]("name", O.Unique)
    def description = column[String]("description")
    def * = (id.?, name, description) <> ((AxisUniverse.apply _).tupled, AxisUniverse.unapply _)
}

object AxisUniverse {
    val universes = TableQuery[UniverseEntity]
    val printFields = Array("id", "name", "description")

    def create(name: String, description: String): Unit = {
        Await.result(DataUtils.db.run(
            universes += AxisUniverse.apply(None, name, description)
        ), Duration.Inf)
    }

    def list(): Seq[UniverseEntity#TableElementType] = {
        Await.result(DataUtils.db.run(
            universes.result
        ), Duration.Inf)
    }

    def find(name: String): Seq[UniverseEntity#TableElementType] = {
        Await.result(DataUtils.db.run(
            universes.filter(_.name === name).result
        ), Duration.Inf)
    }

    def delete(name: String): Unit = {
        val affectedRowsCount = Await.result(DataUtils.db.run(
            universes.filter(_.name === name).delete
        ), Duration.Inf)
        assert(affectedRowsCount > 0, s"Universe with name: ${name} not found")
    }

    def update(name: String, newName: String, newDescription: String): Unit = {
        var entries = find(name)
        if (newName != null) {
            entries.foreach(_.name = newName)
        }
        if (newDescription != null) {
            entries.foreach(_.description = newDescription)
        }
        val affectedRowsCount = Await.result(DataUtils.db.run(
            DBIO.sequence(entries.collect(e => universes.update(e)))
        ), Duration.Inf)
        assert(affectedRowsCount.nonEmpty && affectedRowsCount.forall(_ > 0), s"Universe with name: ${name} not found")
    }
}


