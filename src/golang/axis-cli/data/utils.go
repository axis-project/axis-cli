package data

import (
	"fmt"
	"strings"
)

var skipFields []string = []string{"deleted_at", "updated_at"}

func PrintMapEntries(entries []map[string]interface{}, fields []string) {
	for _, k := range fields {
		fmt.Print(k, "\t\t")
	}
	fmt.Println()
	fmt.Println(strings.Repeat("--------\t\t", len(fields)))
	for _, entry := range entries {
		for _, k := range fields {
			fmt.Print(entry[k], "\t\t")
		}
		fmt.Println()
	}
}
