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

    private let config: BenjiConnectConfig
    private let onClose: () -> Void

    private var webView: WKWebView!
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

    deinit {
        if let router, let webView {
            router.detach(from: webView)
        }
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 400),
            contentView.heightAnchor.constraint(equalToConstant: 645)
        ])

        // Tap outside to exit
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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

    // MARK: - WebView + Router

    private func setupWebViewAndRouter() {
        let userContentController = WKUserContentController()

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView = webView

        contentView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])

        // Router handles decoding and calling config callbacks
        let expectedOrigin = Endpoints.expectedOrigin(for: config.environment)
        let router = BenjiConnectMessageRouter(
            config: config,
            expectedOrigin: expectedOrigin,
            close: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
                self.onClose()
            }
        )
        self.router = router
        router.attach(to: webView)
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

    // MARK: - Test helper (optional)

    /// Call this instead of `loadConnect()` when you want to test locally without a server.
    func loadTestHTML() {
        let html = """
        <!doctype html>
        <html>
          <body>
            <h3>Benji Connect Test Page</h3>
            <script>
              function send(msg) {
                window.webkit.messageHandlers.benjiConnect.postMessage(msg);
              }

              setTimeout(() => {
                send({
                  type: "FLOW_EXIT",
                  data: { step: "verify_phone", trigger: "CLOSE_BUTTON_CLICKED" }
                });
              }, 1200);
            </script>
          </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: URL(string: "https://example.com"))
    }
}
