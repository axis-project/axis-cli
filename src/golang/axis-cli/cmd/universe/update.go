/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package universe

import (
	"axis-cli/data/AxisUniverse"

	"github.com/spf13/cobra"
)

var newName, newDescription string

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
		err := AxisUniverse.Update(args[0], newName, newDescription)
		return err
	},
}

func init() {
	updateCmd.Flags().StringVar(&newName, "name", "", "New name for the universe")
	updateCmd.Flags().StringVarP(&newDescription, "description", "d", "", "New description for the universe")
}
