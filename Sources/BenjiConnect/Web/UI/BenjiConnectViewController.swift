//
//  BenjiConnectViewController.swift
//
//
//  Created by Marta Wilgan on 12/11/25.
//

import UIKit
import WebKit

@MainActor
final class BenjiConnectViewController: UIViewController {
    
    private let backdropView = UIView()
    private let consoleForwarder = ConsoleForwarder()

    private let config: BenjiConnectConfig
    private var isDismissing = false
    private let onClose: () -> Void

    private var router: BenjiConnectMessageRouter?
    private var webView: WKWebView!
    private var webViewFactory: BenjiWebViewFactory?

    // UI container for “modal card”
    private let contentView = UIView()

    init(config: BenjiConnectConfig, onClose: @escaping () -> Void) {
        self.config = config
        self.onClose = onClose
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebView()
        loadConnect()
    }

    // MARK: - UI

    private func setupUI() {
        backdropView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backdropView)
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tap.cancelsTouchesInView = false
        backdropView.addGestureRecognizer(tap)

        // Modal card
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = true

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = view.safeAreaLayoutGuide

        // Keep it centered *when possible* (lower priority)
        let centerY = contentView.centerYAnchor.constraint(equalTo: safe.centerYAnchor)
        centerY.priority = .defaultHigh

        // Keyboard-aware bottom limit (iOS 15+)
        let bottomToKeyboard = contentView.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor, constant: -16)
        bottomToKeyboard.priority = .required

        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            centerY,

            // Maintain margins
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: safe.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(lessThanOrEqualTo: safe.trailingAnchor, constant: -16),
            contentView.topAnchor.constraint(greaterThanOrEqualTo: safe.topAnchor, constant: 16),
            bottomToKeyboard,

            // Prefer a nice “card” size but don’t force it
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            contentView.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 1.0, constant: -32).withPriority(.defaultHigh),

            contentView.heightAnchor.constraint(lessThanOrEqualToConstant: 645),
            contentView.heightAnchor.constraint(equalTo: safe.heightAnchor, constant: -32).withPriority(.defaultHigh),
        ])
        
//        contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 280).isActive = true
//        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }

    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        guard !isDismissing else { return }
        let location = sender.location(in: view)
        
        // Dismiss only if tap is outside the modal card and not already dismissing
        if !contentView.frame.contains(location) {
            isDismissing = true
            
            // Dismiss on main thread
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                // Resign first responder
                webView.endEditing(true)
                
                self.dismiss(animated: true) { [config] in
                    let base = BenjiConnectMetadata(
                        context: .init(namespace: BenjiConnectConstants.namespace, version: BenjiConnectConstants.version),
                        extras: [:]
                    )
                    let metadata = BenjiConnectOnExitMetadata(
                        base: base,
                        trigger: BenjiConnectExitTrigger.tappedOutOfBounds.rawValue,
                        step: nil
                    )
                    config.onExit?(metadata)
                }
                self.onClose()
            }
        }
    }

    // MARK: - Bridge + Router + WebView
    
    private func setupRouter() {
        let expectedOrigin = Endpoints.expectedOrigin(for: config.environment)
        let router = BenjiConnectMessageRouter(config: config, expectedOrigin: expectedOrigin) { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
            self.onClose()
        }
        self.router = router
    }

    private func setupWebView() {
        
        setupRouter()

        let factory = BenjiWebViewFactory(
            router: self.router!,
            consoleForwarder: consoleForwarder
        )
        self.webView = factory.makeWebView()
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webViewFactory = factory

        contentView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        webView.setContentHuggingPriority(.defaultLow, for: .vertical)
        webView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        webView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        webView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.layoutIfNeeded()
    }

    private func loadConnect() {
        guard let url = Builder.buildConnectURL(environment: config.environment, token: config.token) else {
            let err = NSError(
                domain: "BenjiConnectSDK",
                code: 1002,
                userInfo: [NSLocalizedDescriptionKey: "Failed to build Connect URL"]
            )
            let md = BenjiConnectMetadata(
                context: .init(namespace: BenjiConnectConstants.namespace, version: BenjiConnectConstants.version),
                extras: [:]
            )
            config.onError?(err, "500", md)
            return
        }

        webView.load(URLRequest(url: url))
    }
}

extension BenjiConnectViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.endEditing(true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail navigation:", error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation:", error)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("web content process terminated")
    }
}

extension BenjiConnectViewController: WKUIDelegate {
    
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        
        guard navigationAction.targetFrame == nil else { return nil }
        guard let factory = self.webViewFactory else { return nil }

        let popupVC = BenjiPopupWebViewController(
            configuration: configuration,
            factory: factory
        )
        popupVC.loadViewIfNeeded()
        present(popupVC, animated: true)
        return popupVC.webView
    }
}

final class ConsoleForwarder: NSObject, WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      Logger.debug("ConsoleForwarder: \(message.body)")
  }
}
