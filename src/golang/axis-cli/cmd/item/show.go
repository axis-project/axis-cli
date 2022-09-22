/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package item

import (
	"axis-cli/data"
	"axis-cli/data/AxisItem"

	"strconv"

	"github.com/spf13/cobra"
)

// showCmd represents the show command
var showCmd = &cobra.Command{
	Use:   "show",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Args: cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		id, err := strconv.ParseUint(args[0], 10, 64)
		if err != nil {
			return err
		}
		entry, err := AxisItem.FindToMap(id)
		if err != nil {
			return err
		}
		data.PrintMapEntries([]map[string]interface{}{entry}, fieldsToPrint)
		return err
	},
}

func init() {
	ItemCmd.AddCommand(showCmd)
}
