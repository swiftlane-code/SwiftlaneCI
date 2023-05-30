//

import ArgumentParser
import Foundation
import Guardian
import SwiftlaneCore
import Yams
import Simulator
import Swiftlane

public struct UnitTestsLaneCommand: SwiftlaneCommand {
	public static var configuration = CommandConfiguration(
		commandName: "test-calculator",
		abstract: "Custom tests lane for scheme TheCalculator."
	)
	
	@Option(help: "Project dir path.")
	public var projectDir: AbsolutePath

	@OptionGroup public var commonOptions: CommonOptions

	public init() {}
    
    private func overrideDependencies() throws {
        DependencyResolver.shared.register(ExpiringToDoAllowedAuthorsProviding.self) {
            GitLabExpiringToDoAllowedAuthorsProvider(
                logger: DependenciesFactory.resolve(),
                gitlabApi: DependenciesFactory.resolve(),
                gitlabGroupIDToFetchMembers: guardianBeforeBuildConfig().expiringTODOs.gitlabGroupIDToFetchMembersFrom
            )
        }
    }

	public func runCMD() throws {
        try overrideDependencies()
        
		let sharedConfig = try SharedConfigFactory.makeSharedConfig(
			projectDir: projectDir,
			commons: commonOptions
		)
        
//        try TasksFactory.makeGuardianBeforeBuildTask(
//            projectDir: projectDir,
//            commandConfig: guardianBeforeBuildConfig(),
//            sharedConfig: sharedConfig
//        ).run()

		let runTestsTask = try TasksFactory.makeRunTestsTask(
			projectDir: projectDir,
			commandConfig: testsConfig(),
			sharedConfig: sharedConfig
		)

		let logger: Logging = DependenciesFactory.resolve()
		let testsExitCode: Int
		do {
			try runTestsTask.run()
			testsExitCode = 0
		} catch {
			logger.logError(error)
			testsExitCode = 1
		}
		
		try TasksFactory.makeGuardianAfterBuildTask(
			projectDir: projectDir,
			commandConfig: guardianAfterBuildConfig(),
			sharedConfig: sharedConfig,
			unitTestsExitCode: testsExitCode
        ).run()
	}
}
