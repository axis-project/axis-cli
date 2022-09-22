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
	newUniverseName string
)

// moveCmd represents the move command
var moveCmd = &cobra.Command{
	Use:   "move",
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
		err = AxisItem.Update(id, "", "", 0, time.Time{}, newUniverseName, "")
		return err
	},
}

func init() {
	moveCmd.Flags().StringVarP(&newUniverseName, "universe", "u", "", "New universe that the item belongs to")
	moveCmd.MarkFlagRequired("universe")
	ItemCmd.AddCommand(moveCmd)
}
