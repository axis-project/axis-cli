package AxisItem

import (
	"axis-cli/data"
	"axis-cli/data/AxisUniverse"
	"time"

	"gorm.io/gorm"
)

type AxisItem struct {
	gorm.Model
	ID          uint64 `gorm:"primaryKey"`
	Title       string
	Description string
	TimeDue     time.Time
	Priority    uint8
	UniverseID  uint64
	Universe    AxisUniverse.AxisUniverse `gorm:"foreignKey:UniverseID"`
	Status      string
}

func Create(title string, description string, priority uint8, timeDue time.Time, universeName string, status string) error {
	// Create
	if priority == 0 {
		priority = 1
	}
	var universe AxisUniverse.AxisUniverse
	result := data.Db.First(&universe, "name = ?", universeName)
	if result.Error != nil {
		return result.Error
	}
	result = data.Db.Create(&AxisItem{Title: title, Description: description, Priority: priority, TimeDue: timeDue, Universe: universe, Status: status})
	return result.Error
}

func List() ([]AxisItem, error) {
	// Read
	var items []AxisItem
	result := data.Db.Model(&AxisItem{}).Limit(10).Find(&items)
	return items, result.Error
}

func ListToMap() ([]map[string]interface{}, error) {
	// Read
	var itemMaps []map[string]interface{}
	result := data.Db.Model(&AxisItem{}).Limit(10).Find(&itemMaps)
	return itemMaps, result.Error
}

func Find(id uint64) (AxisItem, error) {
	// Read
	var item AxisItem
	result := data.Db.First(&item, id)
	return item, result.Error
}

func FindToMap(id uint64) (map[string]interface{}, error) {
	// Read
	var itemMap map[string]interface{}
	result := data.Db.Model(&AxisItem{}).First(&itemMap, id)
	return itemMap, result.Error
}

func SearchToMap(keywords []string, searchDecription bool) ([]map[string]interface{}, error) {
	// Read
	var itemMaps []map[string]interface{}
	// TODO: enable searching description
	// TODO: enable searching multiple keywords
	result := data.Db.Model(&AxisItem{}).Where("title LIKE ?", "%"+keywords[0]+"%").Find(&itemMaps)
	return itemMaps, result.Error
}

func Update(id uint64, newTitle string, newDescription string, newPriority uint8, newTimeDue time.Time, newUniverseName string, newStatus string) error {
	var item AxisItem
	result := data.Db.First(&item, id)
	if newTitle != "" {
		item.Title = newTitle
	}
	if newDescription != "" {
		item.Description = newDescription
	}
	if newPriority != 0 {
		item.Priority = newPriority
	}
	if !newTimeDue.IsZero() {
		item.TimeDue = newTimeDue
	}
	if newUniverseName != "" {
		var universe AxisUniverse.AxisUniverse
		result := data.Db.First(&universe, "name = ?", newUniverseName)
		if result.Error != nil {
			return result.Error
		}
		item.UniverseID = universe.ID
	}
	if newStatus != "" {
		item.Status = newStatus
	}
	data.Db.Save(&item)
	return result.Error
}

func Delete(id uint64) error {
	var item AxisItem
	result := data.Db.First(&item, id)
	data.Db.Delete(&item)
	return result.Error
}

// func (u *AxisUniverse) BeforeDelete(tx *gorm.DB) (err error) {
// 	if u.Role == "admin" {
// 		return errors.New("admin user not allowed to delete")
// 	}
// 	return
// }

func init() {
	// Migrate the schema
	data.Db.AutoMigrate(&AxisItem{})
}
