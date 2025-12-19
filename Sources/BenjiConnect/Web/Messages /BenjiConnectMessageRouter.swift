//
//  BenjiConnectMessageRouter.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation
import WebKit

/*
 * Routes messages from Connect JS to iOS Connect SDK Callbacks
 */

@MainActor
public final class BenjiConnectMessageRouter: NSObject, WKScriptMessageHandler {

    public static let handlerName = "benjiConnectRouter"

    private let config: BenjiConnectConfig
    private let expectedOrigin: String
    private let close: () -> Void

    public init(
        config: BenjiConnectConfig,
        expectedOrigin: String,
        close: @escaping () -> Void
    ) {
        self.config = config
        self.expectedOrigin = expectedOrigin
        self.close = close
        super.init()
    }

    // WKScriptMessageHandler entry point
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        handle(message: message)
    }

    private func handle(message: WKScriptMessage) {
        // Optional origin check (careful with popups/subframes)
        // if let url = message.frameInfo.request.url, url.originString != expectedOrigin { return }

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
