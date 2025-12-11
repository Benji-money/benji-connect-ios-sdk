import UIKit
import WebKit

/// Main SDK class for BenjiConnect
/// This class provides the primary interface for integrating Benji Connect into iOS applications
@objc public class BenjiConnect: NSObject {
    
    // MARK: - Properties
    
    /// The configuration used to initialize this instance
    @objc public let config: BenjiConnectConfig
    
    /// Delegate for receiving events
    @objc public weak var delegate: BenjiConnectDelegate?
    
    /// The view controller that presents the BenjiConnect interface
    private var presentingViewController: UIViewController?
    
    /// The web view wrapper
    private var webView: BenjiConnectWebView?
    
    /// The view controller containing the web view
    private var webViewController: UIViewController?
    
    // MARK: - Initialization
    
    /// Initialize BenjiConnect with a configuration
    /// - Parameter config: The configuration object
    @objc public init(config: BenjiConnectConfig) {
        self.config = config
        super.init()
    }
    
    /// Convenience initializer for Objective-C
    /// - Parameters:
    ///   - clientId: The client ID provided by Benji
    ///   - environment: The environment to connect to
    @objc public convenience init(clientId: String, environment: String) {
        let config = BenjiConnectConfig(clientId: clientId, environment: environment)
        self.init(config: config)
    }
    
    // MARK: - Public Methods
    
    /// Present the BenjiConnect interface
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - animated: Whether to animate the presentation
    ///   - completion: Optional completion handler
    @objc public func present(from viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.presentingViewController = viewController
        
        // Create web view
        let webView = BenjiConnectWebView(config: config, eventHandler: self)
        self.webView = webView
        
        // Create view controller
        let webVC = UIViewController()
        webVC.view = webView
        webVC.modalPresentationStyle = .fullScreen
        
        // Add close button
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(closeButtonTapped)
        )
        webVC.navigationItem.rightBarButtonItem = closeButton
        webVC.title = "Benji Connect"
        
        // Wrap in navigation controller
        let navController = UINavigationController(rootViewController: webVC)
        navController.modalPresentationStyle = .fullScreen
        self.webViewController = navController
        
        // Present
        viewController.present(navController, animated: animated) { [weak self] in
            // Load the web view after presentation
            self?.webView?.load()
            completion?()
        }
    }
    
    /// Dismiss the BenjiConnect interface
    /// - Parameters:
    ///   - animated: Whether to animate the dismissal
    ///   - completion: Optional completion handler
    @objc public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        webViewController?.dismiss(animated: animated) { [weak self] in
            self?.cleanup()
            completion?()
        }
    }
    
    /// Reload the BenjiConnect interface
    @objc public func reload() {
        webView?.reload()
    }
    
    // MARK: - Private Methods
    
    @objc private func closeButtonTapped() {
        let event = BenjiConnectEvent(type: .exit)
        handleEvent(event)
        dismiss()
    }
    
    private func cleanup() {
        webView = nil
        webViewController = nil
        presentingViewController = nil
    }
}

// MARK: - BenjiConnectEventHandler

extension BenjiConnect: BenjiConnectEventHandler {
    
    internal func handleEvent(_ event: BenjiConnectEvent) {
        // Always call the general event handler
        delegate?.benjiConnect?(self, didReceiveEvent: event)
        
        // Call specific delegate methods based on event type
        switch event.type {
        case .loaded:
            delegate?.benjiConnectDidLoad?(self)
            
        case .success:
            if let data = event.data {
                delegate?.benjiConnect?(self, didSucceedWithData: data)
            }
            // Auto-dismiss on success (optional behavior)
            // dismiss()
            
        case .exit:
            delegate?.benjiConnectDidExit?(self)
            
        case .error:
            if let error = event.error {
                delegate?.benjiConnect?(self, didFailWithError: error)
            } else if let data = event.data,
                      let errorMessage = data["message"] as? String {
                let error = BenjiConnectError.error(code: .unknown, message: errorMessage)
                delegate?.benjiConnect?(self, didFailWithError: error)
            }
            
        case .accountSelected:
            if let data = event.data {
                delegate?.benjiConnect?(self, didSelectAccountWithData: data)
            }
            
        case .institutionSelected:
            if let data = event.data {
                delegate?.benjiConnect?(self, didSelectInstitutionWithData: data)
            }
            
        case .custom:
            // Custom events are only handled by the general event handler
            break
        }
        
        if config.debugMode {
            print("[BenjiConnect] Event handled: \(event.type)")
        }
    }
}
