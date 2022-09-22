package AxisUniverse

import (
	"axis-cli/data"

	"gorm.io/gorm"
)

type AxisUniverse struct {
	gorm.Model
	ID          uint64 `gorm:"primaryKey"`
	Name        string `gorm:"uniqueIndex"`
	Description string
}

func Create(name string, description string) error {
	// Create
	result := data.Db.Create(&AxisUniverse{Name: name, Description: description})
	return result.Error
}

func List() ([]AxisUniverse, error) {
	// Read
	var universes []AxisUniverse
	result := data.Db.Model(&AxisUniverse{}).Limit(10).Find(&universes)
	return universes, result.Error
}

func ListToMap() ([]map[string]interface{}, error) {
	// Read
	var universeMaps []map[string]interface{}
	result := data.Db.Model(&AxisUniverse{}).Limit(10).Find(&universeMaps)
	return universeMaps, result.Error
}

func Find(name string) (AxisUniverse, error) {
	// Read
	var universe AxisUniverse
	result := data.Db.Model(&AxisUniverse{}).First(&universe, "name = ?", name)
	return universe, result.Error
}

func FindToMap(name string) (map[string]interface{}, error) {
	// Read
	var universeMap map[string]interface{}
	result := data.Db.Model(&AxisUniverse{}).First(&universeMap, "name = ?", name)
	return universeMap, result.Error
}

func Update(name string, newName string, newDescription string) error {
	var universe AxisUniverse
	result := data.Db.Model(&AxisUniverse{}).First(&universe, "name = ?", name)
	if newName != "" {
		universe.Name = newName
	}
	if newDescription != "" {
		universe.Description = newDescription
	}
	// data.Db.Model(&universe).Updates(universe)
	data.Db.Save(&universe)
	return result.Error
}

func Delete(name string) error {
	// TODO: fail when deleting non-empty universe
	var universe AxisUniverse
	result := data.Db.First(&universe, "name = ?", name)
	data.Db.Delete(&universe)
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
	data.Db.AutoMigrate(&AxisUniverse{})
}
