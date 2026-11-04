import Foundation
import os

/// Keeps secrets supplied through environment variables out of child processes.
///
/// Every child process spawned by xcodes or its dependencies (sudo, xcodebuild, aria2, xip, open, ...)
/// inherits the process environment. `removeFromProcessEnvironment()` moves the sensitive variables
/// into memory at launch, so they stay readable through `Current.shell.env` but are never inherited.
public enum SensitiveEnvironment {
    /// Variables that must never be passed to child processes.
    public static let variableNames: Set<String> = ["XCODES_PASSWORD"]

    private static let captured = OSAllocatedUnfairLock<[String: String]>(initialState: [:])

    /// Returns `environment` with all sensitive variables removed.
    public static func scrubbed(_ environment: [String: String]) -> [String: String] {
        environment.filter { !variableNames.contains($0.key) }
    }

    /// Captures the sensitive variables in memory and unsets them from the process environment.
    public static func removeFromProcessEnvironment() {
        captured.withLock { captured in
            for name in variableNames {
                guard let value = getenv(name) else { continue }
                captured[name] = String(cString: value)
                unsetenv(name)
            }
        }
    }

    /// Returns the value of `key`, including sensitive variables captured by `removeFromProcessEnvironment()`.
    public static func value(_ key: String) -> String? {
        captured.withLock { $0[key] } ?? ProcessInfo.processInfo.environment[key]
    }
}
