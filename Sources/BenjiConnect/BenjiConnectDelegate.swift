import Foundation

/// Delegate protocol for receiving BenjiConnect events
/// All methods are optional for flexibility
@objc public protocol BenjiConnectDelegate: AnyObject {
    
    /// Called when the BenjiConnect web view has finished loading
    @objc optional func benjiConnectDidLoad(_ benjiConnect: BenjiConnect)
    
    /// Called when a user successfully connects their account
    /// - Parameters:
    ///   - benjiConnect: The BenjiConnect instance
    ///   - data: Data associated with the successful connection
    @objc optional func benjiConnect(_ benjiConnect: BenjiConnect, didSucceedWithData data: [String: Any])
    
    /// Called when the user exits or closes the BenjiConnect flow
    /// - Parameter benjiConnect: The BenjiConnect instance
    @objc optional func benjiConnectDidExit(_ benjiConnect: BenjiConnect)
    
    /// Called when an error occurs
    /// - Parameters:
    ///   - benjiConnect: The BenjiConnect instance
    ///   - error: The error that occurred
    @objc optional func benjiConnect(_ benjiConnect: BenjiConnect, didFailWithError error: Error)
    
    /// Called when an account is selected
    /// - Parameters:
    ///   - benjiConnect: The BenjiConnect instance
    ///   - data: Data about the selected account
    @objc optional func benjiConnect(_ benjiConnect: BenjiConnect, didSelectAccountWithData data: [String: Any])
    
    /// Called when an institution is selected
    /// - Parameters:
    ///   - benjiConnect: The BenjiConnect instance
    ///   - data: Data about the selected institution
    @objc optional func benjiConnect(_ benjiConnect: BenjiConnect, didSelectInstitutionWithData data: [String: Any])
    
    /// Called for any event received from the web view
    /// - Parameters:
    ///   - benjiConnect: The BenjiConnect instance
    ///   - event: The event object
    @objc optional func benjiConnect(_ benjiConnect: BenjiConnect, didReceiveEvent event: BenjiConnectEvent)
}
