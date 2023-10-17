#!/bin/zsh

set -euo pipefail


repo_dir_name='calculator_repo'

swiftlane_binary_name="SwiftlaneCI"
swiftlane_binary="../.build/debug/$swiftlane_binary_name"
project_dir="$PWD/$repo_dir_name"

export GIT_AUTHOR_EMAIL='swiftlane_ci@example.com'

install_dependencies() {
	export SM_UTILS_PATH='deps/sources'
	export SM_UTILS_BIN_PATH='deps/bin'
	export PATH="$SM_UTILS_BIN_PATH:$PATH"  # Prepend PATH with locally installed utils.

	./install_local_spm_util.sh "https://github.com/MobileNativeFoundation/XCLogParser" "v0.2.36" "xclogparser"
	./install_local_spm_util.sh "https://github.com/tuist/xcbeautify" 					"1.0.0"  "xcbeautify"
}

verify_run_dir() {
	if [ "$(basename $PWD)" != "Examples" ]; then
		echo "This script is intended to be run from the 'Examples' directory." >&2
		exit 1
	fi
}

build_swiftlane_binary() {
	cd ..

	swift build --product $swiftlane_binary_name #-c release

	cd -
}

clean_logs() {
	rm -rf logs
}

reclone_repo() {
	if [ -d "$repo_dir_name" ]; then
		rm -rf "$repo_dir_name"
	fi

	git clone https://github.com/vmzhivetyev/TheCalculator.git "$repo_dir_name"
}

run_tests() {
	export CI_MERGE_REQUEST_SOURCE_BRANCH_NAME="fake_source_branch"
	export CI_MERGE_REQUEST_TARGET_BRANCH_NAME="fake_target_branch"
	export CI_PROJECT_ID="123456789"
	export CI_MERGE_REQUEST_IID="987654321"
	export GITLAB_API_ENDPOINT="https://localhost"
	export PROJECT_ACCESS_TOKEN="aaaaaaaaaaaaaaaa"

	$swiftlane_binary 'test-calculator' \
		--project-dir "$project_dir" \
		--verbose-logfile "$PWD/verbose_log.txt" \
		--log-level 'info'
}

verify_run_dir

install_dependencies

clean_logs

build_swiftlane_binary

reclone_repo

run_tests

echo "OK"
