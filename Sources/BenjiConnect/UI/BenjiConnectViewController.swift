//
//  BenjiConnectViewController.swift
//
//
//  Created by Marta Wilgan on 12/11/25.
//

import UIKit
import WebKit

final class BenjiConnectViewController: UIViewController {

    private let config: BenjiConnectConfig
    private var webView: WKWebView!

    init(config: BenjiConnectConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadConnectURL()
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let contentView = UIView()
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 400),
            contentView.heightAnchor.constraint(equalToConstant: 645)
        ])

        let userContentController = WKUserContentController()
        userContentController.add(self, name: NativeCallbackType.success.rawValue)
        userContentController.add(self, name: NativeCallbackType.exit.rawValue)
        userContentController.add(self, name: NativeCallbackType.error.rawValue)
        userContentController.add(self, name: NativeCallbackType.event.rawValue)

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
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        // Tap outside to exit
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        guard let webView = webView else { return }

        if !webView.frame.contains(location) {
            dismiss(animated: true) {
                let metadata = BenjiConnectOnExitMetadata(
                    context: BenjiConnectMetadataContext(
                        namespace: BenjiConnectConstants.namespace,
                        version: BenjiConnectConstants.version
                    ),
                    step: nil,
                    trigger: BenjiConnectExitTrigger.tappedOutOfBounds.rawValue
                )
                self.config.onExit?(metadata)
            }
        }
    }

    // MARK: - Load URL

    private func loadConnectURL() {
        let baseURL = Endpoints.benjiConnectAuthURL(for: config.environment)
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)

        var queryItems = components?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "connect_token", value: config.token))
        queryItems.append(
            URLQueryItem(
                name: "t",
                value: String(Int(Date().timeIntervalSince1970))
            )
        )
        queryItems.append(URLQueryItem(name: "platform", value: "ios"))

        components?.queryItems = queryItems

        guard let finalURL = components?.url else {
            log("[BenjiConnect] Failed to build connect URL")
            return
        }

        let request = URLRequest(url: finalURL)
        webView.load(request)
    }
}

// MARK: - WKScriptMessageHandler

extension BenjiConnectViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {

        guard let dict = message.body as? [String: Any] else {
            log("[BenjiConnect] Unexpected message body: \(message.body)")
            return
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            switch message.name {
            case NativeCallbackType.success.rawValue:
                let payload = try decoder.decode(OnSuccessPayload.self, from: jsonData)
                handleSuccess(payload)

            case NativeCallbackType.exit.rawValue:
                let payload = try decoder.decode(OnExitPayload.self, from: jsonData)
                handleExit(payload)

            case NativeCallbackType.error.rawValue:
                let payload = try decoder.decode(OnErrorPayload.self, from: jsonData)
                handleError(payload)

            case NativeCallbackType.event.rawValue
                let payload = try decoder.decode(OnEventPayload.self, from: jsonData)
                handleEvent(payload)

            default:
                log("[BenjiConnect] Unknown handler: \(message.name)")
            }
        } catch {
            log("[BenjiConnect] Failed to decode payload for handler \(message.name): \(error)")
        }
    }

    // MARK: - Typed handlers

    private func handleSuccess(_ payload: OnSuccessPayload) {
        dismiss(animated: true) {
            self.config.onSuccess?(payload.token, payload.metadata)
        }
    }

    private func handleExit(_ payload: OnExitPayload) {
        dismiss(animated: true) {
            self.config.onExit?(payload.metadata)
        }
    }

    private func handleError(_ payload: OnErrorPayload) {
        let error = NSError(
            domain: "BenjiConnect",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: payload.errorMessage]
        )

        dismiss(animated: true) {
            self.config.onError?(error, payload.errorId.rawValue, payload.metadata)
        }
    }

    private func handleEvent(_ payload: OnEventPayload) {
        config.onEvent?(payload.type, payload.metadata)
    }
}

