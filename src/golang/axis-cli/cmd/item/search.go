/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package item

import (
	"axis-cli/data"
	"axis-cli/data/AxisItem"
	"strings"

	"github.com/spf13/cobra"
)

var (
	limit            uint
	skip             uint
	searchDecription bool
)

// searchCmd represents the search command
var searchCmd = &cobra.Command{
	Use:   "search",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Args: cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		keywords := strings.Split(args[0], " ")
		// TODO: enable limit & skip
		entries, err := AxisItem.SearchToMap(keywords, searchDecription)
		if err != nil {
			return err
		}
		data.PrintMapEntries(entries, fieldsToPrint)
		return err
	},
}

func init() {
	searchCmd.Flags().UintVarP(&limit, "limit", "n", 20, "")
	searchCmd.Flags().UintVar(&skip, "skip", 0, "")
	searchCmd.Flags().BoolVarP(&searchDecription, "search-description", "d", false, "")
	ItemCmd.AddCommand(searchCmd)
}
