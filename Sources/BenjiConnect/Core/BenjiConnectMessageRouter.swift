//
//  BenjiConnectMessageRouter.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation
import WebKit

@MainActor
public final class BenjiConnectMessageRouter: NSObject {
    public static let handlerName = "benjiConnect"

    private let config: BenjiConnectConfig
    private let expectedOrigin: String
    private let close: () -> Void

    public init(config: BenjiConnectConfig, expectedOrigin: String, close: @escaping () -> Void) {
        self.config = config
        self.expectedOrigin = expectedOrigin
        self.close = close
        super.init()
    }

    public func attach(to webView: WKWebView) {
        webView.configuration.userContentController.add(self, name: Self.handlerName)
    }

    public func detach(from webView: WKWebView) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: Self.handlerName)
    }
}

extension BenjiConnectMessageRouter: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {

        // Best-effort origin check
        // WKScriptMessage doesn't expose origin directly; we can check frame URL.
        if let frameURL = message.frameInfo.request.url,
           let origin = frameURL.originString,
           !expectedOrigin.isEmpty,
           origin != expectedOrigin {
            // Ignore messages from unexpected origins
            return
        }

        // Body should be a JSON object: { type: "...", data: {...} }
        guard let bodyJSON = message.body as? [String: Any],
              let data = try? JSONSerialization.data(withJSONObject: bodyJSON, options: []) else {
            return
        }

        do {
            let decoded = try JSONDecoder().decode(BenjiConnectEventMessage.self, from: data)
            route(decoded)
        } catch {
            let err = NSError(
                domain: "BenjiConnectSDK",
                code: 2001,
                userInfo: [NSLocalizedDescriptionKey: "Failed to decode BenjiConnectEventMessage: \(error)"]
            )
            let md = BenjiConnectMetadata(
                context: .init(namespace: BenjiConnectConstants.namespace, version: BenjiConnectConstants.version),
                extras: [:]
            )
            config.onError?(err, "500", md)
        }
    }

    private func route(_ message: BenjiConnectEventMessage) {
        switch message {
        case .authSuccess(let data):
            let event = Mapper.mapToAuthSuccessEventData(data: data)
            config.onEvent?(event.type, event.metadata)

        case .flowExit(let data):
            let exitData = Mapper.mapToOnExitData(data: data)
            config.onExit?(exitData.metadata)
            close()

        case .flowSuccess(let data):
            let successData = Mapper.mapToOnSuccessData(data: data)
            config.onSuccess?(successData.token, successData.metadata)

        case .event(let raw):
            let eventData = Mapper.mapToOnEventData(type: .event, rawData: raw)
            config.onEvent?(eventData.type, eventData.metadata)

        case .error(let data):
            let errorData = Mapper.mapToOnErrorData(data: data)
            config.onError?(errorData.error, errorData.errorID, errorData.metadata)
        }
    }
}

