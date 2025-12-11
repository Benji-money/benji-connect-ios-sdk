import Foundation

/// Configuration object for initializing BenjiConnect SDK
/// Compatible with Objective-C via @objc annotation
@objc public class BenjiConnectConfig: NSObject {
    
    /// The client ID provided by Benji
    @objc public let clientId: String
    
    /// The environment to connect to (e.g., "production", "sandbox", "development")
    @objc public let environment: String
    
    /// Optional user ID for the session
    @objc public let userId: String?
    
    /// Optional metadata to pass to the web view
    @objc public let metadata: [String: Any]?
    
    /// The base URL for the Benji Connect web interface
    @objc public let baseURL: String
    
    /// Whether to enable debug logging
    @objc public let debugMode: Bool
    
    /// Initialize with required parameters
    /// - Parameters:
    ///   - clientId: The client ID provided by Benji
    ///   - environment: The environment to connect to (default: "production")
    ///   - userId: Optional user ID for the session
    ///   - metadata: Optional metadata dictionary
    ///   - baseURL: The base URL for Benji Connect (default: production URL)
    ///   - debugMode: Enable debug logging (default: false)
    @objc public init(
        clientId: String,
        environment: String = "production",
        userId: String? = nil,
        metadata: [String: Any]? = nil,
        baseURL: String = "https://connect.benji.money",
        debugMode: Bool = false
    ) {
        self.clientId = clientId
        self.environment = environment
        self.userId = userId
        self.metadata = metadata
        self.baseURL = baseURL
        self.debugMode = debugMode
        super.init()
    }
    
    /// Convenience initializer for Objective-C compatibility
    @objc public convenience init(clientId: String, environment: String) {
        self.init(clientId: clientId, environment: environment, userId: nil, metadata: nil)
    }
    
    /// Build the full URL with query parameters
    internal func buildURL() -> URL? {
        guard var components = URLComponents(string: baseURL) else {
            return nil
        }
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "clientId", value: clientId),
            URLQueryItem(name: "environment", value: environment)
        ]
        
        if let userId = userId {
            queryItems.append(URLQueryItem(name: "userId", value: userId))
        }
        
        if let metadata = metadata {
            if let jsonData = try? JSONSerialization.data(withJSONObject: metadata, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                queryItems.append(URLQueryItem(name: "metadata", value: jsonString))
            }
        }
        
        components.queryItems = queryItems
        return components.url
    }
}
