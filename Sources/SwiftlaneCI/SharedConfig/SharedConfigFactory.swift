//

import Foundation
import Swiftlane
import SwiftlaneCore

enum SharedConfigFactory {
	static func makeSharedConfig(projectDir: AbsolutePath, commons: CommonOptions) throws -> SharedConfigData {
		let swiftlaneBuilds = try RelativePath("../swiftlane_builds")
		
		let sharedConfig = SharedConfigModel(
			sharedValues: SharedConfigValues(
				jiraProjectKey: "PROJ",
				jiraRequestsTimeout: 30,
				gitAuthorName: "swiftlane-ci",
				gitAuthorEmail: "swiftlane-ci@example.com"
			),
			pathsConfig: PathsConfig(
				xclogparserJSONReportName: try .init("xclogparser_report.json"),
				xclogparserHTMLReportDirName: try .init("build_report_html"),
				mergedJUnitName: try .init("_merged_result.junit"),
				mergedXCResultName: nil,
				xccovFileName: try .init("xccov_report.json"),
				projectFile: try .init("TheCalculator.xcodeproj"),
				derivedDataDir: .relative(swiftlaneBuilds.appending(suffix: "/derived_data")),
				testRunsDerivedDataDir: .relative(swiftlaneBuilds.appending(suffix: "/test_runs_derived_data")),
				logsDir: .relative(swiftlaneBuilds.appending(suffix: "/logs")),
				resultsDir: .relative(swiftlaneBuilds.appending(suffix: "/results")),
				archivesDir: .relative(swiftlaneBuilds.appending(suffix: "/archives")),
				swiftlintConfigPath: try Path(".swiftlint.yml"),
				swiftlintWarningsJsonsFolder: try Path("ProjectWarnings/SwiftLint"),
				tempDir: .relative(swiftlaneBuilds.appending(suffix: "/temp")),
				xcodebuildFormatterCommand: "xcbeautify"
			)
		)

		let paths = PathsFactory(
			pathsConfig: sharedConfig.pathsConfig,
			projectDir: projectDir,
			logger: DependenciesFactory.resolve()
		)

		return SharedConfigData(values: sharedConfig.sharedValues, paths: paths)
	}
}
