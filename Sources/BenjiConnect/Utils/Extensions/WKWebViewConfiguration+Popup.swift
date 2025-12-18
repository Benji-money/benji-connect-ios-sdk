//
//  WKWebViewConfiguration+Popup.swift
//  BenjiConnect
//
//  Created by Marta Wilgan on 12/17/25.
//

import WebKit

extension WKWebViewConfiguration {
    
    static func makePopupConfiguration(from base: WKWebViewConfiguration) -> WKWebViewConfiguration {
        
        let config = WKWebViewConfiguration()

        // Share cookies/session with opener
        config.websiteDataStore = base.websiteDataStore
        config.processPool = base.processPool

        // Keep settings consistent
        config.preferences.javaScriptCanOpenWindowsAutomatically =
            base.preferences.javaScriptCanOpenWindowsAutomatically

        // NEW controller to avoid handler-name collisions
        let controller = WKUserContentController()

        // Copy existing user scripts from the opener config (diagnostics, console forwarders, etc.)
        for script in base.userContentController.userScripts {
            controller.addUserScript(script)
        }

        config.userContentController = controller
        return config
    }
}
