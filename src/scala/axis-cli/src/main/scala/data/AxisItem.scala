package data

import slick.jdbc.H2Profile.api._

import java.time.OffsetDateTime
import scala.concurrent.Await
import scala.concurrent.duration.Duration


case class AxisItem(var id: Option[Int], var universeId: Option[Int], var title: String, var description: String = "", var timeDue: OffsetDateTime, var priority: Int, var status: String) {
    def toMap(): Map[String, Any] = {
        Map("id" -> id, "universeId" -> universeId, "title" -> title, "description" -> description, "timeDue" -> timeDue, "priority" -> priority, "status" -> status)
    }
}

class ItemEntity(tag: Tag) extends Table[AxisItem](tag, "Item") {
    def id = column[Int]("id", O.PrimaryKey, O.AutoInc)
    def universeId = column[Int]("universeId")
    def universe = foreignKey("universe", universeId, AxisUniverse.universes)(_.id, onUpdate=ForeignKeyAction.Restrict, onDelete=ForeignKeyAction.Cascade)
    def title = column[String]("title")
    def description = column[String]("description")
    def timeDue = column[OffsetDateTime]("timeDue")
    def priority = column[Int]("priority")
    def status = column[String]("status")
    def * = (id.?, universeId.?, title, description, timeDue, priority, status) <> ((AxisItem.apply _).tupled, AxisItem.unapply _)
}

object AxisItem {
    val items = TableQuery[ItemEntity]
    val printFields = Array("id", "universeId", "title", "description", "timeDue", "priority", "status")

    def create(title: String, universeName: String, description: String, timeDue: OffsetDateTime, priority: Int): Unit = {
        val universe = AxisUniverse.find(universeName)(0)
        var timeDueValid: OffsetDateTime = timeDue
        if (timeDue == null) {
            timeDueValid = OffsetDateTime.now()
        }
        var priorityValid: Int = priority
        if (priorityValid == 0) {
            priorityValid = 1
        }
        Await.result(DataUtils.db.run(
            items += AxisItem.apply(None, universe.id, title, description, timeDueValid, priorityValid, "New")
        ), Duration.Inf)
    }

    def list(): Seq[ItemEntity#TableElementType] = {
        Await.result(DataUtils.db.run(
            items.result
        ), Duration.Inf)
    }

    def search(keyword: String, searchDescription: Boolean): Seq[ItemEntity#TableElementType] = {
        var filter: ItemEntity => Rep[Boolean] = (e: ItemEntity) => false
        if (searchDescription) {
            filter = (e: ItemEntity) => (e.title.like(s"%${keyword}%") || e.description.like(s"%${keyword}%"))
        } else {
            filter = (e: ItemEntity) => (e.title.like(s"%${keyword}%"))
        }
        Await.result(DataUtils.db.run(
            items.filter(filter).result
        ), Duration.Inf)
    }

    def find(id: Int): Seq[ItemEntity#TableElementType] = {
        Await.result(DataUtils.db.run(
            items.filter(_.id === id).result
        ), Duration.Inf)
    }

    def delete(id: Int): Unit = {
        val affectedRowsCount = Await.result(DataUtils.db.run(
            items.filter(_.id === id).delete
        ), Duration.Inf)
        assert(affectedRowsCount > 0, s"Item with id: ${id} not found")
    }

    def update(id: Int, newTitle: String, newDescription: String, newTimeDue: OffsetDateTime, newPriority: Int, newStatus: String): Unit = {
        var entry = find(id)
        assert(entry.nonEmpty, s"Item with id: ${id} not found")

        var item = entry(0)
        if (newTitle != null && newTitle != "") {
            item.title = newTitle
        }
        if (newDescription != null && newDescription != "") {
            item.description = newDescription
        }
        if (newPriority != 0) {
            item.priority = newPriority
        }
        if (newStatus != null && newStatus != "") {
            item.status = newStatus
        }
        if (newTimeDue != null) {
            item.timeDue = newTimeDue
        }
        Await.result(DataUtils.db.run(
            items.update(item)
        ), Duration.Inf)
    }

    def move(id: Int, universeName: String) = {
        val uEntries = AxisUniverse.find(universeName)
        assert(uEntries.nonEmpty, s"Universe with name: ${universeName} not found")
        val universe = uEntries(0)

        val iEntries = find(id)
        assert(iEntries.nonEmpty, s"Item with id: ${id} not found")
        val item = iEntries(0)

        item.universeId = universe.id
        Await.result(DataUtils.db.run(
            items.update(item)
        ), Duration.Inf)
    }

}


