//
//  BenjiWebviewFactory.swift
//  BenjiConnect
//
//  Created by Marta Wilgan on 12/17/25.
//

import WebKit

@MainActor
public final class BenjiWebViewFactory {

    private let baseConfiguration: WKWebViewConfiguration

    public init(router: BenjiConnectMessageRouter, consoleForwarder: WKScriptMessageHandler? = nil) {
        let userContentController = WKUserContentController()

        // Register router ONCE
        userContentController.add(router, name: BenjiConnectMessageRouter.handlerName)

        if let consoleForwarder {
            userContentController.add(consoleForwarder, name: "benjiConsole")
        }

        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        config.preferences.javaScriptCanOpenWindowsAutomatically = true

        self.baseConfiguration = config
    }

    public func makeWebView() -> WKWebView {
        makeWebView(using: baseConfiguration)
    }

    /// IMPORTANT: Use this for window.open() popups.
    /// WebKit requires the returned WKWebView be created with *the configuration it supplies*.
    public func makeWebView(using configuration: WKWebViewConfiguration) -> WKWebView {
        // Ensure the *same* userContentController is used so messages route to the same router.
        configuration.userContentController = baseConfiguration.userContentController
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = true
        webView.isUserInteractionEnabled = true
        if #available(iOS 16.4, *) { webView.isInspectable = true }
        return webView
    }
}

