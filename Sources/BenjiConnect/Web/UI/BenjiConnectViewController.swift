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
    private let onClose: () -> Void

    private var webView: WKWebView!
    private var webViewFactory: BenjiWebViewFactory?
    private var router: BenjiConnectMessageRouter?

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
        setupWebViewAndRouter()
        loadConnect()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("contentView frame:", contentView.frame)
        print("webView frame:", webView?.frame)
        print("webView pointer layout:", ObjectIdentifier(self.webView!))
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
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 400),
            contentView.heightAnchor.constraint(equalToConstant: 645)
        ])
    }

    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        // Dismiss only if tap is outside the modal card
        if !contentView.frame.contains(location) {
            dismiss(animated: true) { [config] in
                // Fire onExit for iOS-side dismissal
                let base = BenjiConnectMetadata(
                    context: .init(namespace: BenjiConnectConstants.namespace, version: BenjiConnectConstants.version),
                    extras: [:]
                )
                let md = BenjiConnectOnExitMetadata(
                    base: base,
                    trigger: BenjiConnectExitTrigger.tappedOutOfBounds.rawValue,
                    step: nil
                )
                config.onExit?(md)
            }
            onClose()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let p = t.location(in: view)
        let hit = view.hitTest(p, with: event)
        print("HIT VIEW:", hit ?? "nil")
    }

    // MARK: - WebView + Router

    private func setupWebViewAndRouter() {
        
        let expectedOrigin = Endpoints.expectedOrigin(for: config.environment)
        
        let router = BenjiConnectMessageRouter(config: config, expectedOrigin: expectedOrigin) { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
            self.onClose()
        }
        self.router = router

        let factory = BenjiWebViewFactory(router: router, consoleForwarder: consoleForwarder)
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

        webView.evaluateJavaScript("Boolean(window.webkit?.messageHandlers?.benjiConnect)") { result, error in
            print("benjiConnect handler exists:", result ?? "nil", "error:", error as Any)
        }
        print("webView isUserInteractionEnabled:", webView.isUserInteractionEnabled)
        print("contentView subviews:", contentView.subviews)
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
    
    @objc private func testTap() {
        print("✅ WebView tap received")
    }
}

extension BenjiConnectViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("✅ didFinish:", webView.url?.absoluteString ?? "nil")

        webView.evaluateJavaScript("document.readyState") { result, error in
            print("readyState:", result ?? "nil", "error:", error as Any)
        }

        webView.evaluateJavaScript("document.body?.innerText") { result, error in
            print("bodyText:", result ?? "nil", "error:", error as Any)
        }
        
        webView.evaluateJavaScript("document.body ? document.body.innerHTML.length : -1") { result, error in
            print("body.innerHTML.length:", result ?? "nil", "error:", error as Any)
        }
        
        webView.evaluateJavaScript("document.documentElement.outerHTML.length") { result, error in
            print("outerHTML.length:", result ?? "nil", "error:", error as Any)
        }
        
        webView.evaluateJavaScript("window.location.href") { result, error in
            print("href:", result ?? "nil")
        }
        
        webView.evaluateJavaScript("window.self !== window.top") { result, _ in
            print("isInIframe:", result ?? "nil")
        }
        
        webView.evaluateJavaScript("Array.from(document.scripts).map(s => s.src).filter(Boolean)") { r, _ in
          print("script src:", r ?? "nil")
        }

    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("🛑 didFail:", error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("🛑 didFailProvisional:", error)
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

        let popupVC = BenjiPopupWebViewController(factory: factory, configuration: configuration)
        present(popupVC, animated: true)
        return popupVC.webView
    }
}



final class ConsoleForwarder: NSObject, WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    print("🌐 JS:", message.body)
  }
}
