//

import Swiftlane

@main
public struct SwiftlaneCI {
    public static func main() {
		RootCommandRunner().run(
			RootCommand.self
		)
    }
}
