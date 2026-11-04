import XCTest
@testable import xcodes

final class InstallCommandTests: XCTestCase {
    func test_Install_ExperimentalUnxipFlag_IsRejected() {
        XCTAssertThrowsError(try Xcodes.Install.parse(["--latest", "--experimental-unxip"])) { error in
            XCTAssertTrue(Xcodes.Install.message(for: error).contains("--experimental-unxip has been removed"))
        }
    }

    func test_Install_WithoutExperimentalUnxipFlag_Parses() throws {
        XCTAssertNoThrow(try Xcodes.Install.parse(["--latest"]))
    }
}
