//

import Foundation
import Swiftlane
import SwiftlaneCore

public extension UnitTestsLaneCommand {
	func testsConfig() -> RunTestsCommandConfig {
		RunTestsCommandConfig(
			scheme: "DummyProject",
			deviceModel: "iPhone 14",
			osVersion: "16.4",
			simulatorsCount: 1,
			testPlan: nil,
			useMultiScan: false
		)
	}
	
	func guardianAfterBuildConfig() -> GuardianAfterBuildCommandConfig {
		GuardianAfterBuildCommandConfig(
			changesCoverageLimitCheckerConfig: nil,
//            ChangesCoverageLimitChecker.DecodableConfig(
//				filesToIgnoreCheck: [.equals("path/to/ignored_file.swift")],
//				changedLinesCoverageLimit: 40,
//				ignoreCheckForSourceBranches: [.equals("ignored_source_branch_name")],
//				ignoreCheckForTargetBranches: [.hasPrefix("release/")]
//			),
			targetsCoverageLimitCheckerConfig: TargetsCoverageLimitChecker.DecodableConfig(
				excludeFilesFilters: [
					"base" : [
						// UI Related
						.hasSuffix("View.swift"),
						.hasSuffix("Modifier.swift"),
						.hasSuffix("State.swift"),
						.hasSuffix("Style.swift"),
						.hasSuffix("Geometry.swift"),
						.hasSuffix("Cell.swift"),
						.hasSuffix("Row.swift"),
						.hasSuffix("Banner.swift"),
						.hasSuffix("Header.swift"),
						.hasSuffix("Sheet.swift"),
						.hasSuffix("Card.swift"),
						.hasSuffix("Grid.swift"),
						.hasSuffix("Data.swift"),
						.hasSuffix("Bar.swift"),
						.hasSuffix("Section.swift"),
						.hasSuffix("Shape.swift"),
						.hasSuffix("Placeholder.swift"),
						.hasSuffix("List.swift"),
						.hasSuffix("Corners.swift"),
						.hasSuffix("Constants.swift"),
						.hasSuffix("Badge.swift"),
						.hasSuffix("Control.swift"),
						.hasSuffix("Coordinator.swift"),
						.hasSuffix("Repr.swift"),
						.hasSuffix("BarItem.swift"),
						.hasSuffix("Overlay.swift"),
						.contains("Appearance"),
						.contains("Button"),
						.contains("TextField"),
						.contains("Image"),
						.contains("Label"),
						.contains("Dependencies"),
						.contains("Toolbar"),
						.contains("Slider"),
						.contains("Layout"),
						.contains("Transition"),
						.contains("Activity"),
						.contains("NavBar"),
						.contains("Animation"),
						.contains("Scroll"),
						.contains("Color"),
						.hasSuffix("Images.swift"),
						try! .regex("/Fonts?/"),
						try! .regex("/Views?/"),
						.contains("Coordinator"),
						// Builders etc.
						.hasSuffix("Assembly.swift"),
						.hasSuffix("Builder.swift"),
						.hasSuffix("ing.swift"),
						.hasSuffix("Factory.swift"),
						.hasSuffix("Configurator.swift"),
						.hasSuffix("+.swift"),
						// Other
						.hasSuffix("Logger.swift"),
						.contains("/ResponseObjects/"),
						.contains("/DataTypes/"),
						.contains("/Router/"),
					]
				],
				targetCoverageLimits: [
					"DummyProject" : .init(limit: 60, filtersSetsNames: ["base"]),
				],
				allowedProductNameSuffixes: [
					".app",
					".framework",
				],
				excludeTargetsNames: [
					.hasSuffix("Mocks"),
				],
                totalCodeCoverageMessagePrefix: nil
			),
			buildWarningCheckerConfig: BuildWarningsChecker.DecodableConfig(
				failBuildWhenWarningsDetected: true,
				ignoreWarningTitle: [
					.equals("Redundant conformance constraint 'Self' : 'AutoMockable'"),
				],
				ignoreWarningLocation: [
					.contains("abracadabra example"),
				],
				ignoreWarningType: [
					.contains("abracadabra example"),
				]
			),
            slatherReportFilePath: try! Path("slather_report.json")
		)
	}
    
    func guardianBeforeBuildConfig() -> GuardianBeforeBuildCommandConfig {
        GuardianBeforeBuildCommandConfig(
            trackingPushRemoteName: "origin",
            trackingNewFoldersCommitMessage: "Added configs to track warnings of new targets",
            loweringWarningLimitsCommitMessage: "Lowered warning limits of some targets",
            expiringTODOs: GuardianBeforeBuildCommandConfig.ExpiringToDos(
                enabled: true,
                warningAfterDaysLeft: 14,
                failIfExpiredDetected: false,
                excludeFilesPaths: [
                    .hasPrefix("Carthage/"),
                    .hasPrefix("Pods/"),
                ],
                excludeFilesNames: [],
                todoDateFormat: "dd.MM.yy",
                needFail: true,
                maxFutureDays: 120,
                ignoreCheckForSourceBranches: [
                    .equals("master"),
                    .hasPrefix("release/"),
                ],
                ignoreCheckForTargetBranches: [
                    .hasPrefix("release/"),
                ],
                gitlabGroupIDToFetchMembersFrom: 9999999,
                blockingConfig: ExpiringToDoBlockingConfig(
                    strategy: ExpiringToDoBlockingConfig.StrategyParams(
                        listedUsersBlock: .team,
                        unlistedTODOAuthorsBlockEveryone: true,
                        unlistedTODOAuthorsAllowed: false,
                        unauthoredTODOAllowed: false,
                        unauthoredTODOBlockEveryone: true
                    ),
                    teams: [
                        "core-team" : [
                            "member.username.1",
                            "member.username.2",
                        ],
                    ]
                )
            ),
            stubsDeclarations: GuardianBeforeBuildCommandConfig.StubDeclarationConfig(
                enabled: false,
                fail: true,
                mocksTargetsPathRegex: #"^Mocks/(\\w+)/"#,
                testsTargetsPathRegex: #"^(\\w+Tests)/"#,
                ignoredFiles: []
            ),
            filesNamingConfig: GuardianBeforeBuildCommandConfig.FilesNamingConfig(
                allowedFilePath: [
                    try! .regex(#"^[a-zA-Z0-9\\/\\_\\.\\+\\-]+$"#)
                ]
            ),
            testableTargetsListFilePath: try! Path("testable_targets_list.generated")
        )
    }
}
