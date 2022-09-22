/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package item

import (
	"axis-cli/data/AxisItem"
	"strconv"
	"time"

	"github.com/spf13/cobra"
)

var (
	newTitle       string
	newDescription string
	newPriority    uint8
	newTimeDueStr  string
	newStatus      string
)

// updateCmd represents the create command
var updateCmd = &cobra.Command{
	Use:   "update",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	RunE: func(cmd *cobra.Command, args []string) error {
		id, err := strconv.ParseUint(args[0], 10, 64)
		if err != nil {
			return err
		}
		var newTimeDue time.Time
		if newTimeDueStr == "" {
			newTimeDue = time.Time{}
			err = nil
		} else {
			newTimeDue, err = time.Parse("2006-01-02 15:04:05 -0700", newTimeDueStr)
		}
		if err != nil {
			return err
		}
		err = AxisItem.Update(id, newTitle, newDescription, newPriority, newTimeDue, "", newStatus)
		return err
	},
}

func init() {
	updateCmd.Flags().StringVar(&newTitle, "title", "", "New title for the item")
	updateCmd.Flags().StringVarP(&newDescription, "description", "d", "", "New description for the universe")
	updateCmd.Flags().Uint8VarP(&newPriority, "priority", "p", 0, "New priority of the item")
	updateCmd.Flags().StringVar(&newTimeDueStr, "due", "", "New due time of the item")
	updateCmd.Flags().StringVarP(&newStatus, "status", "s", "", "New status of then item")
	ItemCmd.AddCommand(updateCmd)
}
