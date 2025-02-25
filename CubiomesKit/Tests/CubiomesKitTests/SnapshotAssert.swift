//
//  SnapshotAssert.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 25-02-2025.
//  Original: https://gist.github.com/jaanus/7e14b31f7f445435aadac09d24397da8
//

import Foundation
import SnapshotTesting
import Testing


/// Test that a piece of data matches.
///
/// - Parameters:
///   - view: The view to test.
///   - testBundleResourceURL: Resource URL that contains a folder with the reference screenshots.
///     For SPM module tests, the folder will be named `__Snapshots__/TestClassName`.
///     For top-level app target tests, the folder will be named simply `TestClassName`.
///   - file: The test file calling this function. No need to pass it, this is determined automatically.
///   - testName: Test function that is calling this function. No need to pass it, this is determined automatically.
///   - line: Line in the test file calling this function. No need to pass it, this is determined automatically.
func assertSnapshot(
    data: Data,
    testBundleResourceURL: URL,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let testClassFileURL = URL(fileURLWithPath: "\(file)", isDirectory: false)
    let testClassName = testClassFileURL.deletingPathExtension().lastPathComponent

    let folderCandidates = [
        // For SPM modules.
        testBundleResourceURL.appending(path: "__Snapshots__").appending(path: testClassName),
        // For top-level xcodeproj app target.
        testBundleResourceURL.appending(path: testClassName),
    ]

    // Default case: snapshots are not present in test bundle. This will fall back to standard SnapshotTesting behavior,
    // where the snapshots live in `__Snapshots__` folder that is adjacent to the test class.
    var snapshotDirectory: String? = nil

    for folder in folderCandidates {
        let referenceSnapshotURLInTestBundle = folder.appending(
            path: "\(sanitizePathComponent(testName))")
        if FileManager.default.fileExists(atPath: referenceSnapshotURLInTestBundle.path(percentEncoded: false)) {
            // The snapshot file is present in the test bundle, so we will instruct snapshot-testing to use the folder
            // pointing to the snapshots in the test bundle, instead of the default.
            // This is the code path that Xcode Cloud will follow, if everything is set up correctly.
            snapshotDirectory = folder.path(percentEncoded: false)
        }
    }

    let failure = SnapshotTesting.verifySnapshot(
        of: data,
        as: .data,
        record: false,
        snapshotDirectory: snapshotDirectory,
        file: file,
        testName: testName,
        line: line
    )

    if let message = failure {
        Issue
            .record(
                "\(message)",
                sourceLocation: SourceLocation(
                    fileID: file.description,
                    filePath: file.description,
                    line: Int(line),
                    column: 0
                )
            )
    }
}

// Copied from swift-snapshot-testing
fileprivate func sanitizePathComponent(_ string: String) -> String {
    return
        string
        .replacingOccurrences(of: "\\W+", with: "-", options: .regularExpression)
        .replacingOccurrences(of: "^-|-$", with: "", options: .regularExpression)
}
