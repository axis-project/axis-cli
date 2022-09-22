/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package universe

import (
	"axis-cli/data/AxisUniverse"

	"github.com/spf13/cobra"
)

var isForce bool

// deleteCmd represents the delete command
var deleteCmd = &cobra.Command{
	Use:   "delete",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Args: cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		err := AxisUniverse.Delete(args[0])
		return err
	},
}

func init() {
	deleteCmd.Flags().BoolVarP(&isForce, "force", "f", false, "Force delete")
	UniverseCmd.AddCommand(deleteCmd)
}
