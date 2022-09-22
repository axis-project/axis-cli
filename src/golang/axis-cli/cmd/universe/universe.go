/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package universe

import (
	"github.com/spf13/cobra"
)

// UniverseCmd represents the universe command
var UniverseCmd = &cobra.Command{
	Use:   "universe",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
}

var fieldsToPrint = []string{"id", "name", "description"}

func init() {
	UniverseCmd.AddCommand(createCmd)
	UniverseCmd.AddCommand(listCmd)
	UniverseCmd.AddCommand(showCmd)
	UniverseCmd.AddCommand(updateCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// itemCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// itemCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
