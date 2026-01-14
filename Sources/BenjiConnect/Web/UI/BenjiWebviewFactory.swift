//
//  BenjiWebviewFactory.swift
//  BenjiConnect
//
//  Created by Marta Wilgan on 12/17/25.
//

import WebKit

@MainActor
public final class BenjiWebViewFactory {

    private let router: BenjiConnectMessageRouter
    private let consoleForwarder: WKScriptMessageHandler?

    public init(
        router: BenjiConnectMessageRouter,
        consoleForwarder: WKScriptMessageHandler? = nil
    ) {
        self.router = router
        self.consoleForwarder = consoleForwarder
    }

    // Main webview: create our own configuration
    public func makeWebView() -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        attachHandlers(to: config.userContentController)
        return makeWebView(using: config)
    }

    // Popup webview: WebKit supplies the configuration — do NOT replace its userContentController
    public func makeWebView(using configuration: WKWebViewConfiguration) -> WKWebView {
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        attachHandlers(to: configuration.userContentController)

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = true
        webView.isUserInteractionEnabled = true
        if #available(iOS 16.4, *) { webView.isInspectable = true }
        return webView
    }

    // MARK: - Handler attach (instance method, lives INSIDE the class)
    private func attachHandlers(to userContentController: WKUserContentController) {
        // Avoid double-add crashes if you ever reuse a controller.
        // (WebKit popup UCC is usually new, but this makes the factory robust.)
        userContentController.removeScriptMessageHandler(forName: BenjiConnectMessageRouter.handlerName)
        if consoleForwarder != nil {
            userContentController.removeScriptMessageHandler(forName: "benjiConsole")
        }

        userContentController.add(router, name: BenjiConnectMessageRouter.handlerName)

        if let consoleForwarder {
            userContentController.add(consoleForwarder, name: "benjiConsole")
        }
    }
}

