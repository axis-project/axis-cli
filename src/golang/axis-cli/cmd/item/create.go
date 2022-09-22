/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package item

import (
	"axis-cli/data/AxisItem"
	"time"

	"github.com/spf13/cobra"
)

var (
	description  string
	priority     uint8
	timeDueStr   string
	universeName string
)

// createCmd represents the create command
var createCmd = &cobra.Command{
	Use:   "create",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Args: cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		var (
			timeDue time.Time
			err     error
		)
		if timeDueStr == "" {
			timeDue = time.Now()
			err = nil
		} else {
			timeDue, err = time.Parse("2006-01-02 15:04:05 -0700", timeDueStr)
		}
		if err != nil {
			return err
		}
		err = AxisItem.Create(args[0], description, priority, timeDue, universeName, "New")
		return err
	},
}

func init() {
	createCmd.Flags().StringVarP(&description, "description", "d", "", "An optional description of the item")
	createCmd.Flags().Uint8VarP(&priority, "priority", "p", 0, "Priority of the item")
	createCmd.Flags().StringVar(&timeDueStr, "due", "", "Due time of the item")
	createCmd.Flags().StringVarP(&universeName, "universe", "u", "", "Universe that the item belongs to")
	createCmd.MarkFlagRequired("universe")
	ItemCmd.AddCommand(createCmd)
}
