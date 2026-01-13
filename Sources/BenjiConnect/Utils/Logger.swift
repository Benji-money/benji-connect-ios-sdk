//
//  Logging.swift.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

public enum Logger {
    // Enable logs only when BENJI_DEBUG_LOGS=1 is present in the environment (and only in DEBUG builds).
    public static let isEnabled: Bool = {
        #if DEBUG
        return ProcessInfo.processInfo.environment["BENJI_DEBUG_LOGS"] == "1"
        #else
        return false
        #endif
    }()

    @inlinable
    public static func debug(_ message: @autoclosure () -> String) {
        guard isEnabled else { return }
        print(message())
    }
}
