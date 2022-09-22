package data

import (
	"log"
	"os"
	"path/filepath"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var Db *gorm.DB

func init() {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		log.Fatal(err)
	}
	axisHome := filepath.Join(homeDir, ".axis")
	if os.Getenv("AXIS_HOME") != "" {
		axisHome = os.Getenv("AXIS_HOME")
	}
	os.MkdirAll(axisHome, os.ModePerm)
	Db, err = gorm.Open(sqlite.Open(filepath.Join(axisHome, "axis.db")), &gorm.Config{
		// Logger: logger.Default.LogMode(logger.Silent),
	})
	if err != nil {
		panic("failed to connect database")
	}
}
