import XCTest
@testable import XcodesCLIKit

final class SensitiveEnvironmentTests: XCTestCase {
    func test_Scrubbed_RemovesPasswordAndKeepsOtherVariables() {
        let environment = ["XCODES_PASSWORD": "secret", "XCODES_USERNAME": "user", "PATH": "/usr/bin"]

        XCTAssertEqual(SensitiveEnvironment.scrubbed(environment), ["XCODES_USERNAME": "user", "PATH": "/usr/bin"])
    }

    func test_RemoveFromProcessEnvironment_HidesPasswordFromChildProcessesButKeepsItReadable() throws {
        setenv("XCODES_PASSWORD", "secret", 1)
        defer { unsetenv("XCODES_PASSWORD") }

        SensitiveEnvironment.removeFromProcessEnvironment()

        XCTAssertNil(ProcessInfo.processInfo.environment["XCODES_PASSWORD"])
        XCTAssertEqual(SensitiveEnvironment.value("XCODES_PASSWORD"), "secret")

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        let output = String(decoding: pipe.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        process.waitUntilExit()

        XCTAssertFalse(output.contains("XCODES_PASSWORD"))
    }
}
