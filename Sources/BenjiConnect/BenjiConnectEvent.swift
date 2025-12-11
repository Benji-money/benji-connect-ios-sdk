import Foundation

/// Event types that can be received from BenjiConnect
@objc public enum BenjiConnectEventType: Int {
    /// The SDK has been loaded and is ready
    case loaded
    
    /// User has successfully connected their account
    case success
    
    /// User has closed/exited the flow
    case exit
    
    /// An error occurred during the flow
    case error
    
    /// Account selection has been made
    case accountSelected
    
    /// Institution has been selected
    case institutionSelected
    
    /// Additional event for custom handling
    case custom
}

/// Represents an event from BenjiConnect
@objc public class BenjiConnectEvent: NSObject {
    
    /// The type of event
    @objc public let type: BenjiConnectEventType
    
    /// Optional data associated with the event
    @objc public let data: [String: Any]?
    
    /// Optional error if the event type is error
    @objc public let error: Error?
    
    /// Initialize a BenjiConnect event
    /// - Parameters:
    ///   - type: The type of event
    ///   - data: Optional data dictionary
    ///   - error: Optional error object
    @objc public init(type: BenjiConnectEventType, data: [String: Any]? = nil, error: Error? = nil) {
        self.type = type
        self.data = data
        self.error = error
        super.init()
    }
}

/// Errors that can occur in BenjiConnect
@objc public enum BenjiConnectErrorCode: Int {
    /// Configuration error
    case configurationError = 1000
    
    /// Network error
    case networkError = 1001
    
    /// Invalid response from server
    case invalidResponse = 1002
    
    /// User cancelled the operation
    case userCancelled = 1003
    
    /// Unknown error
    case unknown = 9999
}

/// NSError domain for BenjiConnect errors
@objc public class BenjiConnectError: NSObject {
    @objc public static let domain = "com.benji.connect"
    
    /// Create an NSError for BenjiConnect
    /// - Parameters:
    ///   - code: The error code
    ///   - message: The error message
    /// - Returns: An NSError object
    @objc public static func error(code: BenjiConnectErrorCode, message: String) -> NSError {
        return NSError(
            domain: domain,
            code: code.rawValue,
            userInfo: [NSLocalizedDescriptionKey: message]
        )
    }
}
