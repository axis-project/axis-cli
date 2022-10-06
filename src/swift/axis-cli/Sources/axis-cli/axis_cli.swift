import ArgumentParser

@main
struct axis_cli: ParsableCommand {
    static var configuration = CommandConfiguration(
            subcommands: [Universe.self, Item.self])
}
