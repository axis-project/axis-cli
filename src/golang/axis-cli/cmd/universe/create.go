/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package universe

import (
	"axis-cli/data/AxisUniverse"

	"github.com/spf13/cobra"
)

var description string

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
		err := AxisUniverse.Create(args[0], description)
		return err
	},
}

func init() {
	createCmd.Flags().StringVarP(&description, "description", "d", "", "An optional description of the universe")
}
