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
        userContentController.add(self, name: "benjiConnectCallback")

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
                        namespace: "benji-connect-ios",
                        version: "0.1.0"
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

        guard message.name == "benjiConnectCallback" else { return }

        guard let dict = message.body as? [String: Any] else {
            log("[BenjiConnect] Unexpected message body: \(message.body)")
            return
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            let decoder = JSONDecoder()
            // This lets snake_case keys from JS map to camelCase Swift props
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            // First, decode just the `type` for routing
            let basic = try decoder.decode(BasicCallbackEnvelope.self, from: jsonData)

            switch basic.type {
            case .flowSuccess:
                let envelope = try decoder.decode(
                    NativeCallbackEnvelope<OnSuccessPayload>.self,
                    from: jsonData
                )
                handleFlowSuccess(envelope.data)

            case .flowExit:
                let envelope = try decoder.decode(
                    NativeCallbackEnvelope<OnExitPayload>.self,
                    from: jsonData
                )
                handleFlowExit(envelope.data)

            case .error:
                let envelope = try decoder.decode(
                    NativeCallbackEnvelope<OnErrorPayload>.self,
                    from: jsonData
                )
                handleError(envelope.data)

            case .authSuccess, .event:
                let envelope = try decoder.decode(
                    NativeCallbackEnvelope<OnEventPayload>.self,
                    from: jsonData
                )
                handleGenericEvent(type: basic.type, payload: envelope.data)
            }

        } catch {
            log("[BenjiConnect] Failed to decode callback envelope: \(error)")
        }
    }

    // MARK: - Typed handlers

    private func handleFlowSuccess(_ payload: OnSuccessPayload) {
        dismiss(animated: true) {
            self.config.onSuccess?(payload.token, payload.metadata)
        }
    }

    private func handleFlowExit(_ payload: OnExitPayload) {
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

    private func handleGenericEvent(type: BenjiConnectEventType, payload: OnEventPayload) {
        config.onEvent?(type, payload.metadata)
    }
}
