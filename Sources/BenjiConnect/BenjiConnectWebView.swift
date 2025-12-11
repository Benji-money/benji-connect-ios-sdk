import UIKit
import WebKit

/// Internal WebView component that handles the Benji Connect web interface
internal class BenjiConnectWebView: UIView {
    
    // MARK: - Properties
    
    private let webView: WKWebView
    private let config: BenjiConnectConfig
    private weak var eventHandler: BenjiConnectEventHandler?
    private let activityIndicator: UIActivityIndicatorView
    
    // MARK: - Initialization
    
    init(config: BenjiConnectConfig, eventHandler: BenjiConnectEventHandler?) {
        self.config = config
        self.eventHandler = eventHandler
        
        // Configure WKWebView
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        // Create message handler for receiving events from web
        let contentController = WKUserContentController()
        webConfiguration.userContentController = contentController
        
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        // Create activity indicator
        if #available(iOS 13.0, *) {
            self.activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        }
        self.activityIndicator.hidesWhenStopped = true
        
        super.init(frame: .zero)
        
        setupViews()
        setupMessageHandlers(contentController: contentController)
        setupWebViewDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .white
        
        // Add web view
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Add activity indicator
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupMessageHandlers(contentController: WKUserContentController) {
        // Add message handler for events from the web view
        contentController.add(WeakScriptMessageHandler(delegate: self), name: "benjiConnect")
    }
    
    private func setupWebViewDelegates() {
        webView.navigationDelegate = self
    }
    
    // MARK: - Public Methods
    
    func load() {
        guard let url = config.buildURL() else {
            let error = BenjiConnectError.error(
                code: .configurationError,
                message: "Failed to build URL from configuration"
            )
            eventHandler?.handleEvent(BenjiConnectEvent(type: .error, error: error))
            return
        }
        
        if config.debugMode {
            print("[BenjiConnect] Loading URL: \(url.absoluteString)")
        }
        
        activityIndicator.startAnimating()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func reload() {
        webView.reload()
    }
}

// MARK: - WKNavigationDelegate

extension BenjiConnectWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        
        if config.debugMode {
            print("[BenjiConnect] WebView finished loading")
        }
        
        eventHandler?.handleEvent(BenjiConnectEvent(type: .loaded))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
        if config.debugMode {
            print("[BenjiConnect] WebView failed to load: \(error.localizedDescription)")
        }
        
        let connectError = BenjiConnectError.error(
            code: .networkError,
            message: "Failed to load: \(error.localizedDescription)"
        )
        eventHandler?.handleEvent(BenjiConnectEvent(type: .error, error: connectError))
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
        if config.debugMode {
            print("[BenjiConnect] WebView provisional navigation failed: \(error.localizedDescription)")
        }
        
        let connectError = BenjiConnectError.error(
            code: .networkError,
            message: "Failed to load: \(error.localizedDescription)"
        )
        eventHandler?.handleEvent(BenjiConnectEvent(type: .error, error: connectError))
    }
}

// MARK: - WKScriptMessageHandler

extension BenjiConnectWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "benjiConnect" else { return }
        
        if config.debugMode {
            print("[BenjiConnect] Received message from web: \(message.body)")
        }
        
        // Parse the message body
        guard let messageDict = message.body as? [String: Any],
              let eventTypeString = messageDict["type"] as? String else {
            return
        }
        
        // Map event type string to enum
        let eventType: BenjiConnectEventType
        switch eventTypeString.lowercased() {
        case "loaded":
            eventType = .loaded
        case "success":
            eventType = .success
        case "exit", "close":
            eventType = .exit
        case "error":
            eventType = .error
        case "accountselected", "account_selected":
            eventType = .accountSelected
        case "institutionselected", "institution_selected":
            eventType = .institutionSelected
        default:
            eventType = .custom
        }
        
        let data = messageDict["data"] as? [String: Any]
        let event = BenjiConnectEvent(type: eventType, data: data)
        eventHandler?.handleEvent(event)
    }
}

// MARK: - WeakScriptMessageHandler

/// Weak wrapper for WKScriptMessageHandler to prevent retain cycles
private class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

// MARK: - BenjiConnectEventHandler Protocol

/// Internal protocol for handling events from the web view
internal protocol BenjiConnectEventHandler: AnyObject {
    func handleEvent(_ event: BenjiConnectEvent)
}
